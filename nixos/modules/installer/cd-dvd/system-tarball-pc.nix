# This module contains the basic configuration for building a NixOS
# tarball, that can directly boot, maybe using PXE or unpacking on a fs.

{ config, pkgs, ... }:

with pkgs.lib;

let

  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

  # For PXE kernel loading
  pxeconfig = pkgs.writeText "pxeconfig-default" ''
    default menu.c32
    prompt 0

    label bootlocal
      menu default
      localboot 0
      timeout 80
      TOTALTIMEOUT 9000

    label nixos
      MENU LABEL ^NixOS using nfsroot
      KERNEL bzImage
      append ip=dhcp nfsroot=/home/pcroot systemConfig=${config.system.build.toplevel} init=${config.system.build.toplevel}/init rw

    # I don't know how to make this boot with nfsroot (using the initrd)
    label nixos_initrd
      MENU LABEL NixOS booting the poor ^initrd.
      KERNEL bzImage
      append initrd=initrd ip=dhcp nfsroot=/home/pcroot systemConfig=${config.system.build.toplevel} init=${config.system.build.toplevel}/init rw

    label memtest
      MENU LABEL ^${pkgs.memtest86.name}
      KERNEL memtest
  '';

  dhcpdExampleConfig = pkgs.writeText "dhcpd.conf-example" ''
    # Example configuration for booting PXE.
    allow booting;
    allow bootp;

    # Adapt this to your network configuration.
    option domain-name "local";
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.1.255;
    option domain-name-servers 192.168.1.1;
    option routers 192.168.1.1;

    # PXE-specific configuration directives...
    # Some BIOS don't accept slashes for paths inside the tftp servers,
    # and will report Access Violation if they see slashes.
    filename "pxelinux.0";
    # For the TFTP and NFS root server. Set the IP of your server.
    next-server 192.168.1.34;

    subnet 192.168.1.0 netmask 255.255.255.0 {
      range 192.168.1.50 192.168.1.55;
    }
  '';

  readme = ./system-tarball-pc-readme.txt;

in

{
  imports =
    [ ./system-tarball.nix

      # Profiles of this basic installation.
      ../../profiles/all-hardware.nix
      ../../profiles/base.nix
      ../../profiles/installation-device.nix
    ];

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv ];

  tarball.contents =
    [ { source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
        target = "/boot/" + config.system.boot.loader.kernelFile;
      }
      { source = "${pkgs.syslinux}/share/syslinux/pxelinux.0";
        target = "/boot/pxelinux.0";
      }
      { source = "${pkgs.syslinux}/share/syslinux/menu.c32";
        target = "/boot/menu.c32";
      }
      { source = pxeconfig;
        target = "/boot/pxelinux.cfg/default";
      }
      { source = readme;
        target = "/readme.txt";
      }
      { source = dhcpdExampleConfig;
        target = "/boot/dhcpd.conf-example";
      }
      { source = "${pkgs.memtest86}/memtest.bin";
        # We can't leave '.bin', because pxelinux interprets this specially,
        # and it would not load the image fine.
        # http://forum.canardpc.com/threads/46464-0104-when-launched-via-pxe
        target = "/boot/memtest";
      }
    ];

  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;
  jobs.openssh.startOn = pkgs.lib.mkOverrideTemplate 50 {} "";

  # To be able to use the systemTarball to catch troubles.
  boot.crashDump = {
    enable = true;
    kernelPackages = pkgs.linuxPackages_3_4;
  };

  # No grub for the tarball.
  boot.loader.grub.enable = false;

  /* fake entry, just to have a happy stage-1. Users
     may boot without having stage-1 though */
  fileSystems = [
    { mountPoint = "/";
      device = "/dev/something";
      }
  ];

  nixpkgs.config = {
    packageOverrides = p: rec {
      linux_3_4 = p.linux_3_4.override {
        extraConfig = ''
          # Enable drivers in kernel for most NICs.
          E1000 y
          # E1000E y
          # ATH5K y
          8139TOO y
          NE2K_PCI y
          ATL1 y
          ATL1E y
          ATL1C y
          VORTEX y
          VIA_RHINE y
          R8169 y

          # Enable nfs root boot
          UNIX y # http://www.linux-mips.org/archives/linux-mips/2006-11/msg00113.html
          IP_PNP y
          IP_PNP_DHCP y
          FSCACHE y
          NFS_FS y
          NFS_FSCACHE y
          ROOT_NFS y

          # Enable devtmpfs
          DEVTMPFS y
          DEVTMPFS_MOUNT y
        '';
      };
    };
  };
}
