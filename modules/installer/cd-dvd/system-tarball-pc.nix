# This module contains the basic configuration for building a NixOS
# installation CD.

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
      pkgs.xfsprogs
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
    [ # SATA/PATA support.
      "ahci"

      "ata_piix"

      "sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
      "sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
      "sata_uli" "sata_via" "sata_vsc"

      "pata_ali" "pata_amd" "pata_artop" "pata_atiixp"
      "pata_cs5520" "pata_cs5530" "pata_cs5535" "pata_efar"
      "pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
      "pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
      "pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
      "pata_pcmcia" "pata_pdc2027x" "pata_qdi" "pata_rz1000"
      "pata_sc1200" "pata_serverworks" "pata_sil680" "pata_sis"
      "pata_sl82c105" "pata_triflex" "pata_via"
      "pata_winbond"

      # SCSI support (incomplete).
      "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" 

      # USB support, especially for booting from USB CD-ROM
      # drives.
      "usb_storage"

      # Firewire support.  Not tested.
      "ohci1394" "sbp2"

      # Virtio (QEMU, KVM etc.) support.
      "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon"

      # Add vfat to enable people to copy the contents of the CD to a
      # bootable USB stick.
      "vfat"
    ];

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
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv pkgs.klibc pkgs.klibcShrunk ];

  tarball.contents =
    [ { source = config.boot.kernelPackages.kernel + config.system.boot.loader.kernelFile;
        target = "/boot/" + config.system.boot.loader.kernelFile;
      }
    ];
     
  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;
  jobs.sshd.startOn = pkgs.lib.mkOverrideTemplate 50 {} "";
}
