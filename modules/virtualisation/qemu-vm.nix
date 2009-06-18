# This module creates a virtual machine from the NixOS configuration.
# Building the `config.system.build.vm' attribute gives you a command
# that starts a KVM/QEMU VM running the NixOS configuration defined in
# `config'.  The Nix store is shared read-only with the host, which
# makes (re)building VMs very efficient.  However, it also means you
# can't reconfigure the guest inside the guest - you need to rebuild
# the VM in the host.  On the other hand, the root filesystem is a
# read/writable disk image persistent across VM reboots.

{config, pkgs, ...}:

{
  # All the modules the initrd needs to mount the host filesystem via
  # CIFS.  Also use paravirtualised network and block devices for
  # performance.
  boot.initrd.extraKernelModules =
    ["cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8"];

  boot.initrd.postDeviceCommands =
    ''
      ipconfig 10.0.2.15:::::eth0:none
    '';

  # Mount the host filesystem via CIFS, and bind-mount the Nix store
  # of the host into our own filesystem.
  fileSystems =
    [ { mountPoint = "/";
        device = "/dev/vda";
      }
      { mountPoint = "/hostfs";
        device = "//10.0.2.4/qemu";
        fsType = "cifs";
        options = "guest,username=nobody";
        neededForBoot = true;
      }
      { mountPoint = "/nix/store";
        device = "/hostfs/nix/store";
        options = "bind";
        neededForBoot = true;
      }
    ];

  # Starting DHCP brings down eth0, which kills the connection to the
  # host filesystem and thus deadlocks the system.
  networking.useDHCP = false;

  system.build.vm = pkgs.runCommand "nixos-vm" {}
    ''
      ensureDir $out
      ln -s ${config.system.build.system} $out/system

      ensureDir $out/bin
      cat > $out/bin/run-nixos-vm <<EOF
      #! ${pkgs.stdenv.shell}
      export PATH=${pkgs.samba}/sbin:\$PATH
      ${pkgs.kvm}/bin/qemu-system-x86_64 \
        -net nic,model=virtio -net user -smb / \
        -drive file=\$diskImage,if=virtio,boot=on \
        -kernel ${config.system.build.system}/kernel \
        -initrd ${config.system.build.system}/initrd \
        -append "\$(cat ${config.system.build.system}/kernel-params) init=${config.system.build.bootStage2} systemConfig=${config.system.build.system}"
      EOF
      chmod u+x $out/bin/run-nixos-vm
    '';

}
