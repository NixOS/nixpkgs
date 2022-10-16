# `<nixpkgs/nixos/lib/make-disk-image.nix>` {#sec-make-disk-image}

`<nixpkgs/nixos/lib/make-disk-image.nix>` is a function to create _disk image_ in multiple formats: raw, QCOW2 (QEMU image format), QCOW2-Compressed (compressed version), VDI (Virtual Box native format), VPC (VirtualPC).

There are two operations mode for this function:

- either, you want only a Nix store disk image, it can be done using `cptofs` without any virtual machine involved ;
- either, you want a full NixOS install on the disk, it will start a virtual machine to perform various tasks such as partitionning, installation and bootloader installation.

When NixOS tests are running, this function gets called to generate potentially two kinds of disk images:

- a Nix-store only disk image: useful when the test _do not need_ bootloader
- a full-fledged NixOS installation disk image: useful when the test _do need_ to test the bootloader

## Features

- whether to produce a Nix-store only image or not, **this can be incompatible with other options**
- arbitrary NixOS configuration ;
- multiple partition table layouts: EFI, legacy, legacy + GPT, hybrid, none ;
- automatic or bound disk size: `diskSize` parameter, `additionalSpace` can be set when `diskSize` is `auto` to add a constant of disk space ;
- boot partition size when partition table is `efi` or `hybrid` ;
- arbitrary contents with permissions can be placed in the target filesystem using `contents`, incompatible with Nix-store only image
- bootloaders are supported, incompatible with Nix-store only image
- EFI variables can be mutated during image production and the result is exposed in `$out` ;
- system management mode (SMM) can enabled during virtual machine operations ;
- OVMF or EFI firmwares and variables templates can be customized ;
- root filesystem `fsType` can be customized to whatever `mkfs.${fsType}` exist during operations ;
- root filesystem label can be customized, defaults to `nix-store` if it's a nix store image, otherwise `nixpkgs/nixos`
- a `/etc/nixpkgs/nixos/configuration.nix` can be provided through `configFile`, incompatible with a Nix-store only image
- arbitrary code can be executed after the VM has finished its operations with `postVM`
- the current nixpkgs can be realized as a channel in the disk image, which will change the hash of the image when the sources are updated ;
- additional store paths can be provided through `additionalPaths`

Images are **NOT** deterministic, please do not hesitate to try to fix this, source of determinisms are (not exhaustive) :

- bootloader installation have timestamps ;
- SQLite Nix store database contain registration times ;
- UIDs / GIDs Nix mappings are in a non-deterministic order ;
- `/etc/shadow` is in a non-deterministic order

For more, read the function signature source code for documentation on arguments: <https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix>.

## Usage

To produce a Nix-store only image:
```nix
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  make-disk-image = import <nixpkgs/nixos/lib/make-disk-image.nix>;
in
  make-disk-image {
    inherit pkgs lib;
    config = {};
    additionalPaths = [ ];
    format = "qcow2";
    onlyNixStore = true;
    partitionTableType = "none";
    installBootLoader = false;
    touchEFIVars = false;
    diskSize = "auto";
    additionalSpace = "0M"; # Defaults to 512M.
    copyChannel = false;
  }
```

Some arguments can be left out, they are shown explicitly for the sake of the example.

Building this derivation will provide a QCOW2 disk image containing only the Nix store and its registration information.

To produce a NixOS installation image disk with UEFI and bootloader installed:
```nix
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  make-disk-image = import <nixpkgs/nixos/lib/make-disk-image.nix>;
  evalConfig = import <nixpkgs/nixos/lib/eval-config.nix>;
in
  make-disk-image {
    inherit pkgs lib;
    config = evalConfig {
      modules = [
        {
          fileSystems."/" = { device = "/dev/vda"; fsType = "ext4"; autoFormat = true; };
          boot.grub.device = "/dev/vda";
        }
      ];
    };
    format = "qcow2";
    onlyNixStore = false;
    partitionTableType = "legacy+gpt";
    installBootLoader = true;
    touchEFIVars = true;
    diskSize = "auto";
    additionalSpace = "0M"; # Defaults to 512M.
    copyChannel = false;
  }
```

## Technical details

`make-disk-image` has a bit of magic to minimize the amount of work to do in a virtual machine.

It relies on the [LKL (Linux Kernel Library) project](https://github.com/lkl/linux) which provides Linux kernel as userspace library.

Note that Nix-store only image only need to run LKL tools to produce an image and will never spawn a virtual machine, whereas full images will always require a virtual machine, but also use LKL.

### Image preparation phase

Image preparation phase will produce the initial image layout in a folder:

- devise a root folder based on `$PWD`
- preparing the contents by copying and restoring ACLs in this root folder ;
- load in the Nix store database all additional paths computed by `pkgs.closureInfo` in a temporary Nix store ;
- run `nixos-install` in a temporary folder ;
- transfer from the temporary store the additional paths registered to the installed NixOS ;
- do fancy computations for the size of the disk image based on the apparent size of the root folder ;
- partition the disk image using the corresponding script according to the partition table type ;
- format the partitions if needed ;
- use `cptofs` (LKL tool) to copy the root folder inside the disk image

At this step, the disk image contains already the Nix store, it only needs to be converted to the desired format to be used.

### Image conversion phase

Using `qemu-img`, the disk image is converted from a raw format to the desired format: qcow2(-compressed), vdi, vpc.

### Partitionning script based on layouts

#### `none`

No partition table layout is written.

#### `legacy`

This partition table type is composed of a MBR and one primary ext4 partition starting at 1MiB extending to the full disk image.

It is unsuitable for UEFI.

#### `legacy+gpt`

This partition table type uses GPT and:

- create a "no filesystem" partition from 1MiB to 2MiB ;
- set `bios_grub` flag on this "no filesystem" partition, which is some sort of MBR ;
- create a primary ext4 partition starting at 2MiB and extending to the full disk image ;
- perform optimal alignments checks on each partition

This partition has no ESP partition, it is unsuitable for EFI boot which requires an ESP partition, but it can work with CSM (Compatibility Support Module) which emulates BIOS for UEFI.

#### `efi`

This partition table type uses GPT and:

- creates an FAT32 ESP partition from 8MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
- create a primary ext4 partition starting after the boot one and extending to the full disk image

#### `hybrid`

This partition table type uses GPT and:

- creates a "no filesystem" partition from 0 to 1MiB, set `bios_grub` flag on it ;
- creates an FAT32 ESP partition from 8MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
- creates a primary ext4 partition starting after the boot one and extending to the full disk image

This partition could be booted by a BIOS able to understand GPT layouts and recognizing the MBR at the start.

### How to run determinism analysis on results?

Run your derivation with `--check` to rebuild it and verify it is the same.

Once it fails, you will be left with two folders with one having `.check`.

`diffoscope` is not able at the moment to diff two QCOW2 filesystems, it is advised to use raw format.

But even with raw formats, `diffoscope` cannot diff the partition table and partitions recursively.

For this, you can run `fdisk -l $image` and generate `dd if=$image of=$image-p$i.raw skip=$start count=$sectors` for each `(start, sectors)` listed in the `fdisk` output.

With this, you will have each partition as a separate file and you can diffoscope pairs of them to use `diffoscope` ability to read filesystems.
