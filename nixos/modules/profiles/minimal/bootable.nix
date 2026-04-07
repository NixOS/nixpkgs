/*
  A minimal set of NixOS modules that produces a bootable system.

  This is meant to be used with `lib.nixos.evalModules` (the minimal
  entrypoint that loads zero modules by default). It includes only what
  is needed for: kernel, systemd initrd, systemd stage 2, a login
  getty, and basic networking via systemd-networkd.

  Notably absent: nix daemon, bootloader (use UKI or external), X11,
  NetworkManager, firewall, containers, and ~1500 other modules from
  the full `module-list.nix`.

  Usage:

    let
      nixosLib = import (nixpkgs + "/nixos/lib") {
        lib = import (nixpkgs + "/lib");
        featureFlags.minimalModules = {};
      };
    in
    nixosLib.evalModules {
      modules = [
        (nixpkgs + "/nixos/modules/profiles/minimal/bootable.nix")
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          fileSystems."/".device = "/dev/disk/by-label/nixos";
          fileSystems."/".fsType = "ext4";
        }
      ];
    }

  See also: nixos/tests/minimal-bootable.nix
*/
{ lib, modulesPath, ... }:
{

  imports = [
    # Module system plumbing
    (modulesPath + "/misc/nixpkgs.nix")
    (modulesPath + "/misc/assertions.nix")
    (modulesPath + "/misc/lib.nix")
    (modulesPath + "/misc/ids.nix")
    (modulesPath + "/misc/extra-arguments.nix")
    (modulesPath + "/misc/meta.nix")
    (modulesPath + "/misc/version.nix")
    (modulesPath + "/misc/passthru.nix")

    # Activation & toplevel
    (modulesPath + "/system/activation/nixos-init.nix")
    (modulesPath + "/system/activation/pre-switch-check.nix")
    (modulesPath + "/system/activation/top-level.nix")
    (modulesPath + "/system/activation/activation-script.nix")
    (modulesPath + "/system/activation/activatable-system.nix")
    (modulesPath + "/system/activation/bootspec.nix")
    (modulesPath + "/system/activation/specialisation.nix")

    # Boot chain (kernel → systemd initrd → stage 2 → systemd)
    (modulesPath + "/system/boot/kernel.nix")
    (modulesPath + "/system/boot/modprobe.nix")
    (modulesPath + "/system/boot/stage-1.nix")
    (modulesPath + "/system/boot/stage-2.nix")
    (modulesPath + "/system/boot/systemd.nix")
    (modulesPath + "/system/boot/systemd/tmpfiles.nix")
    (modulesPath + "/system/boot/systemd/journald.nix")
    (modulesPath + "/system/boot/systemd/logind.nix")
    (modulesPath + "/system/boot/systemd/user.nix")
    (modulesPath + "/system/boot/systemd/initrd.nix")
    (modulesPath + "/system/boot/systemd/sysusers.nix")

    # UKI + EFI (no bootloader)
    (modulesPath + "/system/boot/uki.nix")
    (modulesPath + "/system/boot/loader/loader.nix")
    (modulesPath + "/system/boot/loader/efi.nix")

    # /etc, environment, programs
    (modulesPath + "/system/etc/etc-activation.nix")
    (modulesPath + "/config/shells-environment.nix")
    (modulesPath + "/config/system-environment.nix")
    (modulesPath + "/config/system-path.nix")
    (modulesPath + "/config/locale.nix")
    (modulesPath + "/config/i18n.nix")
    (modulesPath + "/config/console.nix")
    (modulesPath + "/config/terminfo.nix")
    (modulesPath + "/config/sysctl.nix")
    (modulesPath + "/config/nsswitch.nix")
    (modulesPath + "/programs/environment.nix")
    (modulesPath + "/programs/bash/bash.nix")
    (modulesPath + "/programs/shadow.nix")

    # Users & security
    (modulesPath + "/config/users-groups.nix")
    (modulesPath + "/security/pam.nix")
    (modulesPath + "/security/wrappers/default.nix")

    # Hardware & filesystems
    (modulesPath + "/services/hardware/udev.nix")
    (modulesPath + "/tasks/filesystems.nix")
    (modulesPath + "/tasks/filesystems/ext.nix")
    (modulesPath + "/tasks/filesystems/vfat.nix")

    # Services
    (modulesPath + "/services/ttys/getty.nix")
    (modulesPath + "/services/system/userborn.nix")
    (modulesPath + "/services/system/nscd.nix")
    (modulesPath + "/services/system/dbus.nix")
  ];
}
