# Linux mouse fix
A program to automate the process of fixing multi event mouse issue without having to deal with linux and tools to find and combine them.
It uses `evdev` for reading events from kernel space event files and `uinput` for creating virtual event file to pass the events correctly.

## Installation
[Download](https://github.com/graymind75/linux_mouse_fix/releases) binary from release section.

## Usage
* ##### 1- Move the binary file to `/usr/local/bin/` and path should be `/usr/local/bin/mouse_fix`.
* ##### 2- Give executable permission to the binary: `sudo chmod +x /usr/local/bin/mouse_fix`
* ##### 3- Run `sudo mouse_fix test` to see if the issue has been fixed, after test just press `ctrl + c` to exit test mode.
* ##### 4- If everything was OK, just run: `sudo mouse_fix init`
  * If this doesn't work for you, create an issue and add result of `sudo mouse_fix test` to the issue, We will fix it together!
* ##### 5- That's it!

If anything fails, run `sudo mouse_fix remove` to remove systemd service files until we found a workaround.
