# `<nixpkgs/nixos/lib/make-disk-image.nix>` {#sec-make-disk-image}

`<nixpkgs/nixos/lib/make-disk-image.nix>` is a function to create _disk images_ in multiple formats: raw, QCOW2 (QEMU), QCOW2-Compressed (compressed version), VDI (VirtualBox), VPC (VirtualPC).

This function can create images in two ways:

- using `cptofs` without any virtual machine to create a Nix store disk image,
- using a virtual machine to create a full NixOS installation.

When testing early-boot or lifecycle parts of NixOS such as a bootloader or multiple generations, it is necessary to opt for a full NixOS system installation.
Whereas for many web servers, applications, it is possible to work with a Nix store only disk image and is faster to build.

NixOS tests also use this function when preparing the VM. The `cptofs` method is used when `virtualisation.useBootLoader` is false (the default). Otherwise the second method is used.

## Features {#sec-make-disk-image-features}

For reference, read the function signature source code for documentation on arguments: <https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix>.
Features are separated in various sections depending on if you opt for a Nix-store only image or a full NixOS image.

### Common {#sec-make-disk-image-features-common}

- arbitrary NixOS configuration
- automatic or bound disk size: `diskSize` parameter, `additionalSpace` can be set when `diskSize` is `auto` to add a constant of disk space
- multiple partition table layouts: EFI, legacy, legacy + GPT, hybrid, none through `partitionTableType` parameter
- OVMF or EFI firmwares and variables templates can be customized
- root filesystem `fsType` can be customized to whatever `mkfs.${fsType}` exist during operations
- root filesystem label can be customized, defaults to `nix-store` if it's a Nix store image, otherwise `nixpkgs/nixos`
- arbitrary code can be executed after disk image was produced with `postVM`
- the current nixpkgs can be realized as a channel in the disk image, which will change the hash of the image when the sources are updated
- additional store paths can be provided through `additionalPaths`

### Full NixOS image {#sec-make-disk-image-features-full-image}

- arbitrary contents with permissions can be placed in the target filesystem using `contents`
- a `/etc/nixpkgs/nixos/configuration.nix` can be provided through `configFile`
- bootloaders are supported
- EFI variables can be mutated during image production and the result is exposed in `$out`
- boot partition size when partition table is `efi` or `hybrid`

### On bit-to-bit reproducibility {#sec-make-disk-image-features-reproducibility}

Images are **NOT** deterministic, please do not hesitate to try to fix this, source of determinisms are (not exhaustive) :

- bootloader installation have timestamps
- SQLite Nix store database contain registration times
- `/etc/shadow` is in a non-deterministic order

A `deterministic` flag is available for best efforts determinism.

## Usage {#sec-make-disk-image-usage}

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
    inherit (evalConfig {
      modules = [
        {
          fileSystems."/" = { device = "/dev/vda"; fsType = "ext4"; autoFormat = true; };
          boot.grub.device = "/dev/vda";
        }
      ];
    }) config;
    format = "qcow2";
    onlyNixStore = false;
    partitionTableType = "legacy+gpt";
    installBootLoader = true;
    touchEFIVars = true;
    diskSize = "auto";
    additionalSpace = "0M"; # Defaults to 512M.
    copyChannel = false;
    memSize = 2048; # Qemu VM memory size in megabytes. Defaults to 1024M.
  }
```
