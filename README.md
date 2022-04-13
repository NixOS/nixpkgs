# WFS Tools
WFS (WiiU File System) Tools based on [wfslib](https://github.com/koolkdev/wfslib)

## Status
[![Build status](https://img.shields.io/github/workflow/status/koolkdev/wfs-tools/Build.svg?style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/actions)
[![Github stats](https://img.shields.io/github/downloads/koolkdev/wfslib/total.svg?style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/releases)
[![Latest release](https://img.shields.io/github/release-pre/koolkdev/wfs-tools?style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/releases)

## Usage

### wfs-extract
```
wfs-extract --help
```
```
Usage: wfs-extract --input <input file> --output <output directory> --otp <opt path> [--seeprom <seeprom path>] [--mlc] [--usb] [--dump-path <directory to dump>] [--verbose]
Allowed options:
  --help                produce help message
  --input arg           input file
  --output arg          ouput directory
  --otp arg             otp file
  --seeprom arg         seeprom file (required if usb)
  --dump-path arg (=/)  directory to dump (default: "/")
  --mlc                 device is mlc (default: device is usb)
  --usb                 device is usb
  --verbose             verbose output
```

### wfs-file-injector
Change the content of files in wfs image. The injected file size must be smaller than the allocated size on the disk.
**WARNING: May corrupt the file system, Use at your own risk. Make sure to backup the wfs image.**
```
Usage: wfs-file-injector --image <wfs image> --inject-file <file to inject> --inject-path <file path in wfs> --otp <opt path> [--seeprom <seeprom path>] [--mlc] [--usb]
Allowed options:
  --help                produce help message
  --image arg           wfs image file
  --inject-file arg     file to inject
  --inject-path arg     wfs file path to replace
  --otp arg             otp file
  --seeprom arg         seeprom file (required if usb)
  --mlc                 device is mlc (default: device is usb)
  --usb                 device is usb
```

### wfs-fuse (Linux only)
```
wfs-fuse --help
```
```
usage: wfs-fuse <device_file> <mountpoint> --otp <otp_path> [--seeprom <seeprom_path>] [--usb] [--mlc] [fuse options]

options:
    --help|-h              print this help message
    --otp <path>           otp file
    --seeprom <path>       seeprom file (required if usb)
    --usb                  device is usb (default)
    --mlc                  device is mlc
    -d   -o debug          enable debug output (implies -f)
    -o default_permissions check access permission instead the operation system
    -o allow_other         allow access to the mount for all users
    -f                     foreground operation
    -s                     disable multi-threaded operation

```

### Example
#### Dump mlc from backup
```
wfs-extract --input mlc.full.img --output dump_dir --otp otp.bin --mlc
```

#### Dump USB device under Windows
(Needed to be run with administrator previliges, so run from privileged command line)
```
wfs-extract --input \\.\PhysicalDrive3 --output dump_dir --otp otp.bin --seeprom seeprom.bin
```
You need to replace PhsyicalDrive3 with the correct device, you can figure it out with this PowerShell command
```
Get-WmiObject Win32_DiskDrive
```

#### Inject rom.zip

```
wfs-file-injector --image usb.img --inject-file rom.zip --inject-path /usr/title/00050000/101c3500/content/0010/rom.zip --otp otp.bin --seeprom seeprom.bin
```

#### Mount USB device in Linux
```
sudo wfs-fuse /dev/sdb /mnt --otp otp.bin --seeprom seeprom.bin -o default_permissions,allow_other
```
(Note: In MacOS you must provide "-o default_permissions,allow_other" argument for wfs-fuse)

## Build
Requirements:
* Visual Studio 2022 / GCC 11+ / LLVM 14+
* CMake 3.20+
* Ninja

To build:
```
git clone https://github.com/koolkdev/wfs-tools.git
cd wfs-tools
git submodule init
git submodule update
cmake --preset default
cmake --build --preset release
```

### Windows:
Visual Studio contains all the requirements for building
You can just open the wfs-tools directory with Visual Studio and build the project

### Linux
```
sudo apt-get install git g++ cmake ninja-build pkg-config libfuse-dev
```

### Mac OS X
Install Xcode command line tools:
```
xcode-select --install
```
[Install Homebrew](https://brew.sh/)  
```
brew install cmake ninja pkg-config
brew cask install osxfuse
```
