# This module creates a virtual machine from the NixOS configuration.
# Building the `config.system.build.vm' attribute gives you a command
# that starts a KVM/QEMU VM running the NixOS configuration defined in
# `config'.  The Nix store is shared read-only with the host, which
# makes (re)building VMs very efficient.  However, it also means you
# can't reconfigure the guest inside the guest - you need to rebuild
# the VM in the host.  On the other hand, the root filesystem is a
# read/writable disk image persistent across VM reboots.

{ config, pkgs, ... }:

with pkgs.lib;

let

  vmName = config.networking.hostName;

  options = {
  
    virtualisation.memorySize = 
      mkOption {
        default = 384;
        description =
          ''
            Memory size (M) of virtual machine.
          '';
      };
      
    virtualisation.diskSize = 
      mkOption {
        default = 512;
        description =
          ''
            Disk size (M) of virtual machine.
          '';
      };
      
    virtualisation.diskImage =
      mkOption {
        default = "./${vmName}.qcow2";
        description =
          ''
            Path to the disk image containing the root filesystem.
            The image will be created on startup if it does not
            exist.
          '';
      };
      
    virtualisation.graphics =
      mkOption {
        default = true;
        description =
          ''
            Whether to run QEMU with a graphics window, or access
            the guest computer serial port through the host tty.
          '';
      };

    virtualisation.pathsInNixDB =
      mkOption {
        default = [];
        description =
          ''
            The list of paths whose closure is registered in the Nix
            database in the VM.  All other paths in the host Nix store
            appear in the guest Nix store as well, but are considered
            garbage (because they are not registered in the Nix
            database in the guest).
          '';
      };

    virtualisation.vlans = 
      mkOption {
        default = [ 1 ];
        example = [ 1 2 ];
        description =
          ''
            Virtual networks to which the VM is connected.  Each
            number <replaceable>N</replaceable> in this list causes
            the VM to have a virtual Ethernet interface attached to a
            separate virtual network on which it will be assigned IP
            address
            <literal>192.168.<replaceable>N</replaceable>.<replaceable>M</replaceable></literal>,
            where <replaceable>M</replaceable> is the index of this VM
            in the list of VMs.
          '';
      };

    networking.primaryIPAddress =
      mkOption {
        default = "";
        internal = true;
        description = "Primary IP address used in /etc/hosts.";
      };

    virtualisation.qemu.options =
      mkOption {
        default = "";
        example = "-vga std";
        description = "Options passed to QEMU.";
      };
      
  };

  cfg = config.virtualisation;

  qemuGraphics = if cfg.graphics then "" else "-nographic";
  kernelConsole = if cfg.graphics then "" else "console=ttyS0";
  ttys = [ "tty1" "tty2" "tty3" "tty4" "tty5" "tty6" ];

  # Shell script to start the VM.
  startVM =
    ''
      #! ${pkgs.stdenv.shell}
      
      export PATH=${pkgs.samba}/sbin:$PATH

      NIX_DISK_IMAGE=''${NIX_DISK_IMAGE:-${config.virtualisation.diskImage}}

      if ! test -e "$NIX_DISK_IMAGE"; then
          ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" ${toString config.virtualisation.diskSize}M || exit 1
      fi
      
      # -no-kvm-irqchip is needed to prevent the CIFS mount from
      # hanging the VM on x86_64.
      exec ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 -m ${toString config.virtualisation.memorySize} \
          -no-kvm-irqchip \
          -net nic,vlan=0,model=virtio -net user,vlan=0 -smb / \
          -drive file=$NIX_DISK_IMAGE,if=virtio,boot=on,werror=report \
          -kernel ${config.system.build.toplevel}/kernel \
          -initrd ${config.system.build.toplevel}/initrd \
          ${qemuGraphics} \
          $QEMU_OPTS \
          -append "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.bootStage2} systemConfig=${config.system.build.toplevel} regInfo=${regInfo} ${kernelConsole} $QEMU_KERNEL_PARAMS" \
          ${config.virtualisation.qemu.options}
    '';

    
  regInfo = pkgs.runCommand "reginfo"
    { exportReferencesGraph =
        map (x: [("closure-" + baseNameOf x) x]) config.virtualisation.pathsInNixDB;
      buildInputs = [ pkgs.perl ];
    }
    ''
      printRegistration=1 perl ${pkgs.pathsFromGraph} closure-* > $out
    '';

in

{
  require = options;

  # All the modules the initrd needs to mount the host filesystem via
  # CIFS.  Also use paravirtualised network and block devices for
  # performance.
  boot.initrd.availableKernelModules =
    [ "cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8" ];

  boot.initrd.extraUtilsCommands =
    ''
      # We need mke2fs in the initrd.
      cp ${pkgs.e2fsprogs}/sbin/mke2fs $out/bin

      # And `ifconfig'.
      cp ${pkgs.nettools}/sbin/ifconfig $out/bin
    '';
      
  boot.initrd.postDeviceCommands =
    ''
      # Set up networking.  Needed for CIFS mounting.
      ifconfig eth0 up 10.0.2.15

      # If the disk image appears to be empty, run mke2fs to
      # initialise.
      FSTYPE=$(blkid -o value -s TYPE /dev/vda || true)
      if test -z "$FSTYPE"; then
          mke2fs -t ext3 /dev/vda
      fi
    '';

  # After booting, register the closure of the paths in
  # `virtualisation.pathsInNixDB' in the Nix database in the VM.  This
  # allows Nix operations to work in the VM.  The path to the
  # registration file is passed through the kernel command line to
  # allow `system.build.toplevel' to be included.  (If we had a direct
  # reference to ${regInfo} here, then we would get a cyclic
  # dependency.)
  boot.postBootCommands =
    ''
      ( source /proc/cmdline
        ${config.environment.nix}/bin/nix-store --load-db < $regInfo
      )
    '';
      
  virtualisation.pathsInNixDB = [ config.system.build.toplevel ];
  
  # Mount the host filesystem via CIFS, and bind-mount the Nix store
  # of the host into our own filesystem.  We use mkOverride to allow
  # this module to be applied to "normal" NixOS system configuration,
  # where the regular value for the `fileSystems' attribute should be
  # disregarded for the purpose of building a VM test image (since
  # those filesystems don't exist in the VM).
  fileSystems = mkOverride 50 {}
    [ { mountPoint = "/";
        device = "/dev/vda";
      }
      { mountPoint = "/hostfs";
        device = "//10.0.2.4/qemu";
        fsType = "cifs";
        options = "guest,username=nobody,noperm,noacl";
        neededForBoot = true;
      }
      { mountPoint = "/nix/store";
        device = "/hostfs/nix/store";
        fsType = "none";
        options = "bind";
        neededForBoot = true;
      }
    ];

  # Starting DHCP brings down eth0, which kills the connection to the
  # host filesystem and thus deadlocks the system.
  networking.useDHCP = false;

  networking.defaultGateway = mkOverride 200 {} "10.0.2.2";

  networking.nameservers = [ "10.0.2.3" ];

  networking.interfaces = singleton
    { name = "eth0";
      ipAddress = "10.0.2.15";
    };

  # Don't run ntpd in the guest.  It should get the correct time from KVM.
  services.ntp.enable = false;
    
  system.build.vm = pkgs.runCommand "nixos-vm" {}
    ''
      ensureDir $out/bin
      ln -s ${config.system.build.toplevel} $out/system
      ln -s ${pkgs.writeScript "run-nixos-vm" startVM} $out/bin/run-${vmName}-vm
    '';

  # sendfile() is currently broken over CIFS, so fix it here for all
  # configurations that use Apache.
  services.httpd.extraConfig =
    ''
      EnableSendFile Off
    '';

  # When building a regular system configuration, override whatever
  # video driver the host uses.
  services.xserver.videoDriver = mkOverride 50 {} null;
  services.xserver.videoDrivers = mkOverride 50 {} [ "cirrus" "vesa" ];
  services.xserver.defaultDepth = mkOverride 50 {} 0;
  services.xserver.resolutions = mkOverride 50 {} [];

  services.mingetty.ttys = ttys ++ optional (!cfg.graphics) "ttyS0";

  # Wireless won't work in the VM.
  networking.enableWLAN = mkOverride 50 {} false;
}
