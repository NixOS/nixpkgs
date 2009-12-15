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
            Whether to run qemu with a graphics window, or access
            the guest computer serial port through the host tty.
          '';
      };

  };

  cfg = config.virtualisation;

  qemuGraphics = if (cfg.graphics) then "" else "-nographic";
  kernelConsole = if (cfg.graphics) then "" else "console=ttyS0";
  ttys = [ "tty1" "tty2" "tty3" "tty4" "tty5" "tty6" ];

  # Shell script to start the VM.
  startVM =
    ''
      #! ${pkgs.stdenv.shell}
      
      export PATH=${pkgs.samba}/sbin:$PATH

      NIX_DISK_IMAGE=''${NIX_DISK_IMAGE:-${config.virtualisation.diskImage}}

      if ! test -e "$NIX_DISK_IMAGE"; then
          ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" 512M || exit 1
      fi
      
      # -no-kvm-irqchip is needed to prevent the CIFS mount from
      # hanging the VM on x86_64.
      exec ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 -m ${toString config.virtualisation.memorySize} \
          -no-kvm-irqchip \
          -net nic,model=virtio -net user -smb / \
          -drive file=$NIX_DISK_IMAGE,if=virtio,boot=on \
          -kernel ${config.system.build.toplevel}/kernel \
          -initrd ${config.system.build.toplevel}/initrd \
          ${qemuGraphics} \
          $QEMU_OPTS \
          -append "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.bootStage2} systemConfig=${config.system.build.toplevel} ${kernelConsole} $QEMU_KERNEL_PARAMS"
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
    '';
      
  boot.initrd.postDeviceCommands =
    ''
      # Set up networking.  Needed for CIFS mounting.
      ipconfig 10.0.2.15:::::eth0:none

      # If the disk image appears to be empty (fstype "unknown";
      # hacky!!!), run mke2fs to initialise.
      eval $(fstype /dev/vda)
      if test "$FSTYPE" = unknown; then
          mke2fs -t ext3 /dev/vda
      fi
    '';

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
        options = "guest,username=nobody,noperm";
        neededForBoot = true;
      }
      { mountPoint = "/nix/store";
        device = "/hostfs/nix/store";
        options = "bind";
        neededForBoot = true;
      }
      # Mount the host's Nix database.  This allows read-only Nix
      # operations in the guest to work properly.
      { mountPoint = "/nix/var/nix/db";
        device = "/hostfs/nix/var/nix/db";
        options = "bind";
      }
    ];

  # Starting DHCP brings down eth0, which kills the connection to the
  # host filesystem and thus deadlocks the system.
  networking.useDHCP = false;

  networking.defaultGateway = "10.0.2.2";

  networking.nameservers = [ "10.0.2.3" ];

  networking.interfaces = singleton
    { name = "eth0";
      ipAddress = "10.0.2.15";
    };

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
