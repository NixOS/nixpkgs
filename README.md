# WFS Tools
WFS (WiiU File System) Tools based on [wfslib](https://github.com/koolkdev/wfslib)

## Status
[![Build status](https://img.shields.io/github/actions/workflow/status/koolkdev/wfs-tools/build.yml?branch=master&style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/actions)
[![Github stats](https://img.shields.io/github/downloads/koolkdev/wfs-tools/total.svg?style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/releases)
[![Latest release](https://img.shields.io/github/release-pre/koolkdev/wfs-tools?style=flat&logo=github)](https://github.com/koolkdev/wfs-tools/releases)

## Usage

### wfs-extract
```
wfs-extract --help
```
```
usage: wfs-extract --input <input file> [--type <type>]
                   [--otp <path> [--seeprom <path>]]
                   [--dump-path <directory to dump>] [--verbose]

options:
  --help                produce help message
  --input arg           input file
  --type arg (=usb)     file type (usb/mlc/plain)
  --otp arg             otp file (for usb/mlc types)
  --seeprom arg         seeprom file (for usb type)
  --output arg          ouput directory
  --dump-path arg (=/)  directory to dump (default: "/")
  --verbose             verbose output
```

### wfs-reencryptor
A tool reencrypt a disk with a new key.
```
usage: wfs-reencryptor --input <input file> [--output <output file>]
                       [--input-type <type>] [--input-otp <path> [--input-seeprom <path>]]
                       [--output-type <type>] [--output-otp <path> [--output-seeprom <path>]]

options:
  --help                  produce help message
  --input arg             input file
  --input-type arg (=usb) input file type (usb/mlc/plain)
  --input-otp arg         input otp file (for usb/mlc types)
  --input-seeprom arg     input seeprom file (for usb type)
  --output arg            output file (default: reencrypt the input file)
  --output-type arg       output file type (default: same as input)
  --output-otp arg        output otp file (for usb/mlc types)
  --output-seeprom arg    output seeprom file (for usb type)
```

### wfs-fuse (Linux/MacOS only)
```
wfs-fuse --help
```
```
usage: wfs-fuse <device_file> <mountpoint> [--type <file type>] [--otp <otp_path> [--seeprom <seeprom_path>]] [fuse options]

options:
    --help|-h              print this help message
    --type [usb/mlc/plain] type of device
    --otp <path>           otp file (for mlc and usb modes)
    --seeprom <path>       seeprom file (for usb mode)
    -d   -o debug          enable debug output (implies -f)
    -o default_permissions check access permission instead the operation system
    -o allow_other         allow access to the mount for all users
    -f                     foreground operation
    -s                     disable multi-threaded operation
```

### wfs-file-injector
Change the content of files in wfs image. The injected file size must be smaller than the allocated size on the disk.
**WARNING: May corrupt the file system, Use at your own risk. Make sure to backup the wfs image.**
```
usage: wfs-file-injector --image <wfs image> [--type <type>]
                         [--otp <path> [--seeprom <path>]]
                         --inject-file <file to inject> --inject-path <file path in wfs>

options:
  --help                produce help message
  --image arg           wfs image file
  --type arg (=usb)     file type (usb/mlc/plain)
  --otp arg             otp file (for usb/mlc types)
  --seeprom arg         seeprom file (for usb type)
  --inject-file arg     file to inject
  --inject-path arg     wfs file path to replace
```

### Example
#### Dump mlc from backup
```
wfs-extract --input mlc.full.img --output dump_dir --type mlc --otp otp.bin
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
* Visual Studio 2022 17.4+ / GCC 13+ / LLVM 17+
* CMake 3.20+
* Ninja

Additional requirements for wfs-fuse: (Linux/MacOS only)
* libfuse

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
sudo apt-get install git g++ cmake ninja-build pkg-config libfuse-dev zip
```

### Mac OS X
Install Xcode command line tools:
```
xcode-select --install
```
[Install Homebrew](https://brew.sh/)  
```
brew install cmake ninja pkg-config
brew install macfuse
```
