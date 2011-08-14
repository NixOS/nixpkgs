# This module contains the basic configuration for building a NixOS
# installation CD.

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
      MENU LABEL ^NixOS base through NFS
      KERNEL bzImage
      append initrd=initrd ip=dhcp tnfsroot=IPADDR:/home/pcroot systemConfig=${config.system.build.toplevel} init=${config.system.build.toplevel}/initrd

    label memtest
      MENU LABEL ^Memtest86+
      KERNEL memtest.bin
  '';

in

{
  require = [
    ./system-tarball.nix
 
   # Profiles of this basic installation.
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
  ];

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv pkgs.klibc pkgs.klibcShrunk ];

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
      { source = "${pkgs.memtest86}/memtest.bin";
        target = "/boot/memtest.bin";
      }
    ];
     
  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;
  jobs.openssh.startOn = pkgs.lib.mkOverrideTemplate 50 {} "";

  boot.initrd.postMountCommands = ''
    for o in $(cat /proc/cmdline); do
      case $o in
        tnfsroot=*)
          set -- $(IFS==; echo $o)
          # TODO: It cannot mount nfs, as maybe it cannot find 'mount.nfs'
          mount $2 /mnt-root
          ;;
        *) ;;
      esac
    done
  '';

  boot.kernelPackages = pkgs.linuxPackages_2_6_39;
  nixpkgs.config = {
    packageOverrides = p: rec {
      linux_2_6_39 = p.linux_2_6_39.override {
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

          # Enable nfs root boot
          IP_PNP y
          IP_PNP_DHCP y
          NFS_FS y
          ROOT_NFS y

          # Enable devtmpfs
          DEVTMPFS y
          DEVTMPFS_MOUNT y
        '';
      };
    };
  };
}
