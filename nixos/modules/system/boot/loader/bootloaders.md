# Bootloaders in NixOS {#sec-bootloaders}

NixOS has a rich and sophisticated boot story.

There are multiple ways to boot NixOS:

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

NixOS supports installing multiple bootloaders at once, most of the users are interested into installing one bootloader,
and this is what the NixOS installers will often do.

Nevertheless, there are situations where it is desirable to install multiple bootloaders at once inside of a NixOS system,
for example:

- an ISO image with GRUB as legacy bootloader and systemd-boot as UEFI bootloader.
- an image with systemd-boot as UEFI bootloader and generic-extlinux-compatible configuration file for any firmware that does not work with UEFI by default, e.g. U-Boot based system.
