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
      {config, pkgs, ...}:

      {
        require = [ ];

        # Add your own options below and run "nixos-rebuild switch".
        # E.g.,
        #   services.openssh.enable = true;
      }
    '';
  

  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

  options = {

    system.nixosVersion = mkOption {
      default = "${builtins.readFile ../../../VERSION}";
      description = ''
        NixOS version number.
      '';
    };
  };
  
in

{
  require =
    [ options
      ./system-tarball.nix
      ../../hardware/network/rt73.nix
    ];


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

  boot.kernelPackages = pkgs.linuxPackages_2_6_35;

  boot.initrd.kernelModules =
    [ # Wait for SCSI devices to appear.
      "scsi_wait_scan"
    ];

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
  networking.enableRT73Firmware = true;
  networking.enableIntel2200BGFirmware = true;

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv ];

  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;

  jobs.openssh.startOn = pkgs.lib.mkOverride 50 {} "";

  services.ttyBackgrounds.enable = false;

  boot.loader.grub.enable = false;
  boot.loader.generationsDir.enable = false;
  system.boot.loader.kernelFile = "/vmlinux";

  nixpkgs.config = {
    platform = pkgs.platforms.fuloong2f_n32;
  };
}
