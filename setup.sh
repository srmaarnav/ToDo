#!/bin/bash

# Exit when error occurs (works as debug mode)
set -e

# go to the dir where script is located, since source code is there
cd "$(dirname "$0")"

# check for package managers
if hash apt >/dev/null 2>&1;
then
    sudo apt install -y pkg-config libglfw3 libglfw3-dev mesa-common-dev libglu1-mesa-dev libxcb1-dev
    sudo apt autoremove
elif hash dnf >/dev/null 2>&1; then
    # Install required packages (for RHEL-based distributions)
    sudo dnf install -y pkgconfig-glfw3-devel mesa-libGL-devel mesa-libGLU-devel libX11-devel
else
    echo "Error: No supported package manager (apt, dnf) found. Cannot install required packages."
    exit 1
fi


# clone build and install cglm
git clone https://github.com/jtanx/libclipboard
cd libclipboard
cmake .
make -j4
sudo make install
cd ..
rm -rf libclipboard

# Clone, build, and install leif
git clone https://github.com/cococry/leif
cd leif
make
sudo make install
cd ..
rm -rf leif

# Build the main project
make
sudo make install

echo "====================="
echo "INSTALLATION FINISHED"
echo "====================="

# Prompt the user to start the app
read -p "Do you want to start the app (y/n): " answer

# Convert the answer to lowercase to handle Y/y and N/n
answer=${answer,,}

# Check the user's response
if [[ "$answer" == "y" ]]; then
    echo "Starting..."
    todo
elif [[ "$answer" == "n" ]]; then
    echo "todo has been installed to your system."
    echo "It can be launched from the terminal with 'todo'."
    echo "A .desktop file is also installed so you can find it in your application launcher."
    echo "You can also use a terminal interface for todo:"
    todo --help
else
    echo "Invalid input. Please enter y or n."
fi