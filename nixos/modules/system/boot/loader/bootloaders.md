# Bootloaders in NixOS {#sec-bootloaders}

NixOS can boot in multiple ways:

- Direct boot of kernel and initrd, see [QEMU Direct Boot](https://qemu-project.gitlab.io/qemu/system/linuxboot.html) or [LinuxBoot](https://www.linuxboot.org/)
- Network boot via [iPXE](https://ipxe.org/), [PXE](https://en.wikipedia.org/wiki/Preboot_Execution_Environment)
- Media boot via CDROMs, DVDs, USBs, SD cards or any "removable media" of the same nature
  - via UEFI
  - via legacy BIOS
  - via a generic-extlinux-compatible configuration file

For each of this option, NixOS may or may not support a specific bootloader backend, for example:

- GRUB supports legacy BIOS and UEFI but not generic-extlinux-compatible configuration files
- systemd-boot supports only UEFI and relies on a working UEFI implementation for many things
- generic-extlinux-compatible is useful for systems like Raspberry Pi or similar

## Installing multiple bootloaders at once {#sec-bootloaders-multiple}

NixOS supports installing multiple bootloaders at once, but most users will only need one bootloader,
and most NixOS installers will do that.

Nevertheless, there are situations where it is desirable to install multiple bootloaders at once inside one system,
for example:

- an ISO image with GRUB as legacy bootloader and systemd-boot as UEFI bootloader.
- an ISO image with systemd-boot as the UEFI bootloader and generic-extlinux-compatible configuration file for any firmware that does not work with UEFI by default, like U-Boot based system.

## How to add a new bootloader ? {#sec-add-new-bootloader}

This section contains implementation guidance on how to add a new bootloader to nixpkgs or to your own configuration.

Supporting a new bootloader for NixOS does not require adding it to nixpkgs explicitly, all you have to do is design a NixOS module adhering to the bootloader interface, here's a skeleton:

```nix
{ config, lib, utils, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.boot.loader.myNewBootLoader;
in
{
  meta = {
    maintainers = with lib.maintainers; [ yourself ];
  };

  options.boot.loader.myNewBootLoader = utils.mkBootLoaderOption {
    enable = mkEnableOption (lib.mdDoc "new bootloader I want to support");
  };

  config = mkIf cfg.enable {
    boot.loader.myNewBootLoader = {
      id = "new-bootloader";
      installHook = "an installation script that takes a top-level path as an argument";
      supportsInitrdSecrets = mkForce false; # does it support the initrd secrets feature or not?
    };
  };
}
```

Once you register this NixOS module in your configuration, you can use `boot.loader.myNewBootLoader.enable = true;` to use it.

### Installation script {#sec-add-new-bootloader-installation-script}

The installation script can be any binary that receives the system top-level as an argument.

It is recommended to extract only the [bootspec document]() from that top-level
path, i.e. `$toplevel/boot.json` and generate the boot entries based only on
that document to avoid observing unstable pieces of data.

If you need data that's not present in the bootspec document, consider setting a bootspec extension
and/or assert for its existence at evaluation time in your NixOS module.

It is recommended to consider the consequences of using an installation script
written in a language requiring a lot of dependencies, as this implies that your
users will have to download the final script's runtime closure, in every rebuild of their configuration they will need to also download the final script's build time closure.

Certain architectures may lack of a certain language ecosystem and will be in
trouble to use your bootloader, if it's available on their architecture.

### Initrd secrets {#sec-add-new-bootloader-initrd-secrets}

Initrd secrets are a bit of a special legacy feature made to avoid leaking
secret data in the world-readable `/nix/store`. It is based on the same idea as
of services secrets, just pass a string path instead of a path to Nix.

At runtime, this string path will be evaluated and copied inside of another
media, this media here is the initrd itself.

The problem is that initrds can be made world readable by mistake, can be read
from another operating system and are unprotected in the boot partition by
definition.

Therefore, initrd secrets usually offer few protection except the one of hiding
the secret data from the Nix store.

You can signal if your bootloader installation scripts knows how to process
existing initrd secrets and synthesize them in the final bootloader files you
will write.

In that case, you will be expected to process either the bootspec document
containing one of the standard extension for initrd secrets or the original
`initrdSecrets` field **or** the NixOS module containing initrd secrets.

Note that initrd secrets are **optional** and you should not assume they are always present.

Consider leaving the initrd pristine instead of applying all the time a
modification to the initrd even in case of no initrd secret. This makes it
easier to relate the initrd on a boot partition and its Nix store counterpart.
