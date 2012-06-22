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
      append ip=dhcp nfsroot=/home/pcroot systemConfig=${config.system.build.toplevel} init=${config.system.build.toplevel}/init

    # I don't know how to make this boot with nfsroot (using the initrd)
    label nixos_initrd
      MENU LABEL NixOS booting the poor ^initrd.
      KERNEL bzImage
      append initrd=initrd ip=dhcp nfsroot=/home/pcroot systemConfig=${config.system.build.toplevel} init=${config.system.build.toplevel}/init

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

  readme = pkgs.writeText "readme.txt" ''
    Let all the files in the system tarball sit in a directory served by NFS (the NFS root)
    like this in exportfs:
      /home/pcroot    192.168.1.0/24(rw,no_root_squash,no_all_squash)

    Run "exportfs -a" after editing /etc/exportfs, for the nfs server to be aware of the
    changes.

    Use a tftp server serving the root of boot/ (from the system tarball).

    In order to have PXE boot, use the boot/dhcpd.conf-example file for your dhcpd server,
    as it will point your PXE clients to pxelinux.0 from the tftp server. Adapt the
    configuration to your network.

    Adapt the pxelinux configuration (boot/pxelinux.cfg/default) to set the path to your
    nfrroot. If you use ip=dhcp in the kernel, the nfs server ip will be taken from
    dhcp and so you don't have to specify it.

    The linux in bzImage includes network drivers for some usual cards.


    QEMU Testing
    ---------------

    You can test qemu pxe boot without having a DHCP server adapted, but having nfsroot,
    like this:
      qemu-system-x86_64 -tftp /home/pcroot/boot -net nic -net user,bootfile=pxelinux.0 -boot n

    I don't know how to use NFS through the qemu '-net user' though.


    QEMU Testing with NFS root and bridged network
    -------------------------------------------------

    This allows testing with qemu as any other host in your LAN.

    Testing with the real dhcpd server requires setting up a bridge and having a tap device.
      tunctl -t tap0
      brctl addbr br0
      brctl addif br0 eth0
      brctl addif tap0 eth0
      ifconfig eth0 0.0.0.0 up
      ifconfig tap0 0.0.0.0 up
      ifconfig br0 up # With your ip configuration

    Then you can run qemu:
      qemu-system-x86_64 -boot n -net tap,ifname=tap0,script=no -net nic,model=e1000
  '';

in

{
  require =
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

  # To have a nicer initrd, even though the initrd can't mount an nfsroot now
  boot.initrd.withExtraTools = true;

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
      linux_3_2 = p.linux_3_2.override {
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
