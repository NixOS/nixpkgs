# This module contains the basic configuration for building a NixOS
# tarball for the sheevaplug.

{ config, lib, pkgs, ... }:

with lib;

let

  # A dummy /etc/nixos/configuration.nix in the booted CD that
  # rebuilds the CD's configuration (and allows the configuration to
  # be modified, of course, providing a true live CD).  Problem is
  # that we don't really know how the CD was built - the Nix
  # expression language doesn't allow us to query the expression being
  # evaluated.  So we'll just hope for the best.
  dummyConfiguration = pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, ... }:

      {
        # Add your own options below and run "nixos-rebuild switch".
        # E.g.,
        #   services.openssh.enable = true;
      }
    '';


  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

  # A clue for the kernel loading
  kernelParams = pkgs.writeText "kernel-params.txt" ''
    Kernel Parameters:
      init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
  '';


in

{
  imports = [ ./system-tarball.nix ];

  # Disable some other stuff we don't need.
  security.sudo.enable = false;

  # Include only the en_US locale.  This saves 75 MiB or so compared to
  # the full glibcLocales package.
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_US/ISO-8859-1"];

  # Include some utilities that are useful for installing or repairing
  # the system.
  environment.systemPackages =
    [ pkgs.w3m # needed for the manual anyway
      pkgs.ddrescue
      pkgs.ccrypt
      pkgs.cryptsetup # needed for dm-crypt volumes

      # Some networking tools.
      pkgs.sshfsFuse
      pkgs.socat
      pkgs.screen
      pkgs.wpa_supplicant # !!! should use the wpa module

      # Hardware-related tools.
      pkgs.sdparm
      pkgs.hdparm
      pkgs.dmraid

      # Tools to create / manipulate filesystems.
      pkgs.btrfs-progs

      # Some compression/archiver tools.
      pkgs.unzip
      pkgs.zip
      pkgs.xz
      pkgs.dar # disk archiver

      # Some editors.
      pkgs.nvi
      pkgs.bvi # binary editor
      pkgs.joe
    ];

  boot.loader.grub.enable = false;
  boot.loader.generationsDir.enable = false;
  system.boot.loader.kernelFile = "uImage";

  boot.initrd.availableKernelModules =
    [ "mvsdio" "reiserfs" "ext3" "ums-cypress" "rtc_mv" "ext4" ];

  boot.postBootCommands =
    ''
      mkdir -p /mnt

      cp ${dummyConfiguration} /etc/nixos/configuration.nix
    '';

  boot.initrd.extraUtilsCommands =
    ''
      copy_bin_and_libs ${pkgs.utillinux}/sbin/hwclock
    '';

  boot.initrd.postDeviceCommands =
    ''
      hwclock -s
    '';

  boot.kernelParams =
    [
      "selinux=0"
      "console=tty1"
      # "console=ttyS0,115200n8"  # serial console
    ];

  boot.kernelPackages = pkgs.linuxPackages_3_4;

  boot.supportedFilesystems = [ "reiserfs" ];

  /* fake entry, just to have a happy stage-1. Users
     may boot without having stage-1 though */
  fileSystems = [
    { mountPoint = "/";
      device = "/dev/something";
      }
  ];

  services.mingetty = {
    # Some more help text.
    helpLine = ''
      Log in as "root" with an empty password.  ${
        if config.services.xserver.enable then
          "Type `start xserver' to start\nthe graphical user interface."
        else ""
      }
    '';
  };

  # Setting vesa, we don't get the nvidia driver, which can't work in arm.
  services.xserver.videoDrivers = [ "vesa" ];

  services.nixosManual.enable = false;

  # Include the firmware for various wireless cards.
  networking.enableRalinkFirmware = true;
  networking.enableIntel2200BGFirmware = true;

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv ];
  tarball.contents = [
    { source = kernelParams;
      target = "/kernelparams.txt";
    }
    { source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
      target = "/boot/" + config.system.boot.loader.kernelFile;
    }
    { source = pkgs.ubootSheevaplug;
      target = "/boot/uboot";
    }
  ];

  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;
  systemd.services.openssh.wantedBy = lib.mkOverride 50 [];

  # cpufrequtils fails to build on non-pc
  powerManagement.enable = false;

  nixpkgs.config = {
    platform = pkgs.platforms.sheevaplug;
  };
}
