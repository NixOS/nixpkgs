# External Bootloader Backends {#sec-bootloader-external}

NixOS has support for several bootloader backends by default: systemd-boot, grub, uboot, etc.
The built-in bootloader backend support is generic and supports most use cases.
Some users may prefer to create advanced workflows around managing the bootloader and bootable entries.

You can replace the built-in bootloader support with your own tooling using the "external" bootloader option.

Imagine you have created a new package called FooBoot.
FooBoot provides a program at `${pkgs.fooboot}/bin/fooboot-install` which takes the system closure's path as its only argument and configures the system's bootloader.

You can enable FooBoot like this:

```nix
{ pkgs, ... }:
{
  boot.loader.external = {
    enable = true;
    installHook = "${pkgs.fooboot}/bin/fooboot-install";
  };
}
```

## Developing Custom Bootloader Backends {#sec-bootloader-external-developing}

Bootloaders should use [RFC-0125](https://github.com/NixOS/rfcs/pull/125)'s Bootspec format and synthesis tools to identify the key properties for bootable system generations.

