{ config, pkgs, ... }:

with pkgs.lib;

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

      { # Add your own options below, e.g.:
        #   services.openssh.enable = true;
        nixpkgs.config.platform = pkgs.platforms.fuloong2f_n32;
      }
    '';


  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

  # A clue for the kernel loading
  kernelParams = pkgs.writeText "kernel-params.txt" ''
    Kernel Parameters:
      init=/boot/init systemConfig=/boot/init ${toString config.boot.kernelParams}
  '';

  # System wide nixpkgs config
  nixpkgsUserConfig = pkgs.writeText "config.nix" ''
    pkgs:
    {
      platform = pkgs.platforms.fuloong2f_n32;
    }
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
    [ pkgs.subversion # for nixos-checkout
      pkgs.w3m # needed for the manual anyway
      pkgs.testdisk # useful for repairing boot problems
      pkgs.mssys # for writing Microsoft boot sectors / MBRs
      pkgs.parted
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
      pkgs.ntfsprogs # for resizing NTFS partitions
      pkgs.btrfsProgs
      pkgs.jfsutils
      pkgs.jfsrec

      # Some compression/archiver tools.
      pkgs.unrar
      pkgs.unzip
      pkgs.zip
      pkgs.xz
      pkgs.dar # disk archiver

      # Some editors.
      pkgs.nvi
      pkgs.bvi # binary editor
      pkgs.joe
    ];

  # The initrd has to contain any module that might be necessary for
  # mounting the CD/DVD.
  boot.initrd.availableKernelModules =
    [ "vfat" "reiserfs" ];

  boot.kernelPackages = pkgs.linuxPackages_3_10;
  boot.kernelParams = [ "console=tty1" ];

  boot.postBootCommands =
    ''
      mkdir -p /mnt

      cp ${dummyConfiguration} /etc/nixos/configuration.nix
    '';

  # Some more help text.
  services.mingetty.helpLine =
    ''

      Log in as "root" with an empty password.  ${
        if config.services.xserver.enable then
          "Type `start xserver' to start\nthe graphical user interface."
        else ""
      }
    '';

  # Include the firmware for various wireless cards.
  networking.enableRalinkFirmware = true;
  networking.enableIntel2200BGFirmware = true;

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv ]
    ++ [
      {
        object = config.system.build.bootStage2;
        symlink = "/boot/init";
      }
      {
        object = config.system.build.toplevel;
        symlink = "/boot/system";
      }
    ];

  tarball.contents = [
    { source = kernelParams;
      target = "/kernelparams.txt";
    }
    { source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
      target = "/boot/" + config.system.boot.loader.kernelFile;
    }
    { source = nixpkgsUserConfig;
      target = "/root/.nixpkgs/config.nix";
    }
  ];

  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;

  jobs.openssh.startOn = pkgs.lib.mkOverrideTemplate 50 {} "";

  boot.loader.grub.enable = false;
  boot.loader.generationsDir.enable = false;
  system.boot.loader.kernelFile = "vmlinux";

  nixpkgs.config = {
    platform = pkgs.platforms.fuloong2f_n32;
  };
}
