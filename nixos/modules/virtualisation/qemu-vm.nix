# This module creates a virtual machine from the NixOS configuration.
# Building the `config.system.build.vm' attribute gives you a command
# that starts a KVM/QEMU VM running the NixOS configuration defined in
# `config'.  The Nix store is shared read-only with the host, which
# makes (re)building VMs very efficient.  However, it also means you
# can't reconfigure the guest inside the guest - you need to rebuild
# the VM in the host.  On the other hand, the root filesystem is a
# read/writable disk image persistent across VM reboots.

{ config, lib, pkgs, ... }:

with lib;
with import ../../lib/qemu-flags.nix { inherit pkgs; };

let

  qemu = config.system.build.qemu or pkgs.qemu_test;

  vmName =
    if config.networking.hostName == ""
    then "noname"
    else config.networking.hostName;

  cfg = config.virtualisation;

  qemuGraphics = if cfg.graphics then "" else "-nographic";
  kernelConsole = if cfg.graphics then "" else "console=${qemuSerialDevice}";
  ttys = [ "tty1" "tty2" "tty3" "tty4" "tty5" "tty6" ];

  # Shell script to start the VM.
  startVM =
    ''
      #! ${pkgs.runtimeShell}

      NIX_DISK_IMAGE=$(readlink -f ''${NIX_DISK_IMAGE:-${config.virtualisation.diskImage}})

      if ! test -e "$NIX_DISK_IMAGE"; then
          ${qemu}/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" \
            ${toString config.virtualisation.diskSize}M || exit 1
      fi

      # Create a directory for storing temporary data of the running VM.
      if [ -z "$TMPDIR" -o -z "$USE_TMPDIR" ]; then
          TMPDIR=$(mktemp -d nix-vm.XXXXXXXXXX --tmpdir)
      fi

      # Create a directory for exchanging data with the VM.
      mkdir -p $TMPDIR/xchg

      ${if cfg.useBootLoader then ''
        # Create a writable copy/snapshot of the boot disk.
        # A writable boot disk can be booted from automatically.
        ${qemu}/bin/qemu-img create -f qcow2 -b ${bootDisk}/disk.img $TMPDIR/disk.img || exit 1

        ${if cfg.useEFIBoot then ''
          # VM needs a writable flash BIOS.
          cp ${bootDisk}/bios.bin $TMPDIR || exit 1
          chmod 0644 $TMPDIR/bios.bin || exit 1
        '' else ''
        ''}
      '' else ''
      ''}

      cd $TMPDIR
      idx=2
      extraDisks=""
      ${flip concatMapStrings cfg.emptyDiskImages (size: ''
        if ! test -e "empty$idx.qcow2"; then
            ${qemu}/bin/qemu-img create -f qcow2 "empty$idx.qcow2" "${toString size}M"
        fi
        extraDisks="$extraDisks -drive index=$idx,file=$(pwd)/empty$idx.qcow2,if=${cfg.qemu.diskInterface},werror=report"
        idx=$((idx + 1))
      '')}

      # Start QEMU.
      exec ${qemuBinary qemu} \
          -name ${vmName} \
          -m ${toString config.virtualisation.memorySize} \
          -smp ${toString config.virtualisation.cores} \
          ${concatStringsSep " " config.virtualisation.qemu.networkingOptions} \
          -virtfs local,path=/nix/store,security_model=none,mount_tag=store \
          -virtfs local,path=$TMPDIR/xchg,security_model=none,mount_tag=xchg \
          -virtfs local,path=''${SHARED_DIR:-$TMPDIR/xchg},security_model=none,mount_tag=shared \
          ${if cfg.useBootLoader then ''
            -drive index=0,id=drive1,file=$NIX_DISK_IMAGE,if=${cfg.qemu.diskInterface},cache=writeback,werror=report \
            -drive index=1,id=drive2,file=$TMPDIR/disk.img,media=disk \
            ${if cfg.useEFIBoot then ''
              -pflash $TMPDIR/bios.bin \
            '' else ''
            ''}
          '' else ''
            -drive index=0,id=drive1,file=$NIX_DISK_IMAGE,if=${cfg.qemu.diskInterface},cache=writeback,werror=report \
            -kernel ${config.system.build.toplevel}/kernel \
            -initrd ${config.system.build.toplevel}/initrd \
            -append "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.toplevel}/init regInfo=${regInfo}/registration ${kernelConsole} $QEMU_KERNEL_PARAMS" \
          ''} \
          $extraDisks \
          ${qemuGraphics} \
          ${toString config.virtualisation.qemu.options} \
          $QEMU_OPTS \
          "$@"
    '';


  regInfo = pkgs.closureInfo { rootPaths = config.virtualisation.pathsInNixDB; };


  # Generate a hard disk image containing a /boot partition and GRUB
  # in the MBR.  Used when the `useBootLoader' option is set.
  # FIXME: use nixos/lib/make-disk-image.nix.
  bootDisk =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "nixos-boot-disk"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/disk.img
              bootFlash=$out/bios.bin
              ${qemu}/bin/qemu-img create -f qcow2 $diskImage "40M"
              ${if cfg.useEFIBoot then ''
                cp ${pkgs.OVMF-CSM.fd}/FV/OVMF.fd $bootFlash
                chmod 0644 $bootFlash
              '' else ''
              ''}
            '';
          buildInputs = [ pkgs.utillinux ];
          QEMU_OPTS = if cfg.useEFIBoot
                      then "-pflash $out/bios.bin -nographic -serial pty"
                      else "-nographic -serial pty";
        }
        ''
          # Create a /boot EFI partition with 40M and arbitrary but fixed GUIDs for reproducibility
          ${pkgs.gptfdisk}/bin/sgdisk \
            --set-alignment=1 --new=1:34:2047 --change-name=1:BIOSBootPartition --typecode=1:ef02 \
            --set-alignment=512 --largest-new=2 --change-name=2:EFISystem --typecode=2:ef00 \
            --attributes=1:set:1 \
            --attributes=2:set:2 \
            --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C1 \
            --partition-guid=1:1C06F03B-704E-4657-B9CD-681A087A2FDC \
            --partition-guid=2:970C694F-AFD0-4B99-B750-CDB7A329AB6F \
            --hybrid 2 \
            --recompute-chs /dev/vda
          . /sys/class/block/vda2/uevent
          mknod /dev/vda2 b $MAJOR $MINOR
          . /sys/class/block/vda/uevent
          ${pkgs.dosfstools}/bin/mkfs.fat -F16 /dev/vda2
          export MTOOLS_SKIP_CHECK=1
          ${pkgs.mtools}/bin/mlabel -i /dev/vda2 ::boot

          # Mount /boot; load necessary modules first.
          ${pkgs.kmod}/bin/insmod ${pkgs.linux}/lib/modules/*/kernel/fs/nls/nls_cp437.ko.xz || true
          ${pkgs.kmod}/bin/insmod ${pkgs.linux}/lib/modules/*/kernel/fs/nls/nls_iso8859-1.ko.xz || true
          ${pkgs.kmod}/bin/insmod ${pkgs.linux}/lib/modules/*/kernel/fs/fat/fat.ko.xz || true
          ${pkgs.kmod}/bin/insmod ${pkgs.linux}/lib/modules/*/kernel/fs/fat/vfat.ko.xz || true
          ${pkgs.kmod}/bin/insmod ${pkgs.linux}/lib/modules/*/kernel/fs/efivarfs/efivarfs.ko.xz || true
          mkdir /boot
          mount /dev/vda2 /boot

          # This is needed for GRUB 0.97, which doesn't know about virtio devices.
          mkdir /boot/grub
          echo '(hd0) /dev/vda' > /boot/grub/device.map

          # Install GRUB and generate the GRUB boot menu.
          touch /etc/NIXOS
          mkdir -p /nix/var/nix/profiles
          ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /boot
        '' # */
    );

in

{
  imports = [ ../profiles/qemu-guest.nix ];

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

    virtualisation.bootDevice =
      mkOption {
        type = types.str;
        example = "/dev/vda";
        description =
          ''
            The disk to be used for the root filesystem.
          '';
      };

    virtualisation.emptyDiskImages =
      mkOption {
        default = [];
        type = types.listOf types.int;
        description =
          ''
            Additional disk images to provide to the VM. The value is
            a list of size in megabytes of each disk. These disks are
            writeable by the VM.
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

    virtualisation.cores =
      mkOption {
        default = 1;
        type = types.int;
        description =
          ''
            Specify the number of cores the guest is permitted to use.
            The number can be higher than the available cores on the
            host system.
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

    virtualisation.writableStore =
      mkOption {
        default = true; # FIXME
        description =
          ''
            If enabled, the Nix store in the VM is made writable by
            layering an overlay filesystem on top of the host's Nix
            store.
          '';
      };

    virtualisation.writableStoreUseTmpfs =
      mkOption {
        default = true;
        description =
          ''
            Use a tmpfs for the writable store instead of writing to the VM's
            own filesystem.
          '';
      };

    networking.primaryIPAddress =
      mkOption {
        default = "";
        internal = true;
        description = "Primary IP address used in /etc/hosts.";
      };

    virtualisation.qemu = {
      options =
        mkOption {
          type = types.listOf types.unspecified;
          default = [];
          example = [ "-vga std" ];
          description = "Options passed to QEMU.";
        };

      networkingOptions =
        mkOption {
          default = [
            "-net nic,netdev=user.0,model=virtio"
            "-netdev user,id=user.0\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
          ];
          type = types.listOf types.str;
          description = ''
            Networking-related command-line options that should be passed to qemu.
            The default is to use userspace networking (slirp).

            If you override this option, be advised to keep
            ''${QEMU_NET_OPTS:+,$QEMU_NET_OPTS} (as seen in the default)
            to keep the default runtime behaviour.
          '';
        };

      diskInterface =
        mkOption {
          default = "virtio";
          example = "scsi";
          type = types.str;
          description = ''
            The interface used for the virtual hard disks
            (<literal>virtio</literal> or <literal>scsi</literal>).
          '';
        };
    };

    virtualisation.useBootLoader =
      mkOption {
        default = false;
        description =
          ''
            If enabled, the virtual machine will be booted using the
            regular boot loader (i.e., GRUB 1 or 2).  This allows
            testing of the boot loader.  If
            disabled (the default), the VM directly boots the NixOS
            kernel and initial ramdisk, bypassing the boot loader
            altogether.
          '';
      };

    virtualisation.useEFIBoot =
      mkOption {
        default = false;
        description =
          ''
            If enabled, the virtual machine will provide a EFI boot
            manager.
            useEFIBoot is ignored if useBootLoader == false.
          '';
      };

  };

  config = {

    boot.loader.grub.device = mkVMOverride cfg.bootDevice;

    boot.initrd.extraUtilsCommands =
      ''
        # We need mke2fs in the initrd.
        copy_bin_and_libs ${pkgs.e2fsprogs}/bin/mke2fs
      '';

    boot.initrd.postDeviceCommands =
      ''
        # If the disk image appears to be empty, run mke2fs to
        # initialise.
        FSTYPE=$(blkid -o value -s TYPE ${cfg.bootDevice} || true)
        if test -z "$FSTYPE"; then
            mke2fs -t ext4 ${cfg.bootDevice}
        fi
      '';

    boot.initrd.postMountCommands =
      ''
        # Mark this as a NixOS machine.
        mkdir -p $targetRoot/etc
        echo -n > $targetRoot/etc/NIXOS

        # Fix the permissions on /tmp.
        chmod 1777 $targetRoot/tmp

        mkdir -p $targetRoot/boot

        ${optionalString cfg.writableStore ''
          echo "mounting overlay filesystem on /nix/store..."
          mkdir -p 0755 $targetRoot/nix/.rw-store/store $targetRoot/nix/.rw-store/work $targetRoot/nix/store
          mount -t overlay overlay $targetRoot/nix/store \
            -o lowerdir=$targetRoot/nix/.ro-store,upperdir=$targetRoot/nix/.rw-store/store,workdir=$targetRoot/nix/.rw-store/work || fail
        ''}
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
        if [[ "$(cat /proc/cmdline)" =~ regInfo=([^ ]*) ]]; then
          ${config.nix.package.out}/bin/nix-store --load-db < ''${BASH_REMATCH[1]}
        fi
      '';

    boot.initrd.availableKernelModules =
      optional cfg.writableStore "overlay"
      ++ optional (cfg.qemu.diskInterface == "scsi") "sym53c8xx";

    virtualisation.bootDevice =
      mkDefault (if cfg.qemu.diskInterface == "scsi" then "/dev/sda" else "/dev/vda");

    virtualisation.pathsInNixDB = [ config.system.build.toplevel ];

    # FIXME: Consolidate this one day.
    virtualisation.qemu.options = mkMerge [
      (mkIf (pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64) [ "-vga std" "-usb" "-device usb-tablet,bus=usb-bus.0" ])
      (mkIf (pkgs.stdenv.isArm || pkgs.stdenv.isAarch64) [ "-device virtio-gpu-pci" "-device usb-ehci,id=usb0" "-device usb-kbd" "-device usb-tablet" ])
    ];

    # Mount the host filesystem via 9P, and bind-mount the Nix store
    # of the host into our own filesystem.  We use mkVMOverride to
    # allow this module to be applied to "normal" NixOS system
    # configuration, where the regular value for the `fileSystems'
    # attribute should be disregarded for the purpose of building a VM
    # test image (since those filesystems don't exist in the VM).
    fileSystems = mkVMOverride (
      { "/".device = cfg.bootDevice;
        ${if cfg.writableStore then "/nix/.ro-store" else "/nix/store"} =
          { device = "store";
            fsType = "9p";
            options = [ "trans=virtio" "version=9p2000.L" "cache=loose" ];
            neededForBoot = true;
          };
        "/tmp" = mkIf config.boot.tmpOnTmpfs
          { device = "tmpfs";
            fsType = "tmpfs";
            neededForBoot = true;
            # Sync with systemd's tmp.mount;
            options = [ "mode=1777" "strictatime" "nosuid" "nodev" ];
          };
        "/tmp/xchg" =
          { device = "xchg";
            fsType = "9p";
            options = [ "trans=virtio" "version=9p2000.L" "cache=loose" ];
            neededForBoot = true;
          };
        "/tmp/shared" =
          { device = "shared";
            fsType = "9p";
            options = [ "trans=virtio" "version=9p2000.L" ];
            neededForBoot = true;
          };
      } // optionalAttrs (cfg.writableStore && cfg.writableStoreUseTmpfs)
      { "/nix/.rw-store" =
          { fsType = "tmpfs";
            options = [ "mode=0755" ];
            neededForBoot = true;
          };
      } // optionalAttrs cfg.useBootLoader
      { "/boot" =
          { device = "/dev/vdb2";
            fsType = "vfat";
            options = [ "ro" ];
            noCheck = true; # fsck fails on a r/o filesystem
          };
      });

    swapDevices = mkVMOverride [ ];
    boot.initrd.luks.devices = mkVMOverride {};

    # Don't run ntpd in the guest.  It should get the correct time from KVM.
    services.timesyncd.enable = false;

    system.build.vm = pkgs.runCommand "nixos-vm" { preferLocalBuild = true; }
      ''
        mkdir -p $out/bin
        ln -s ${config.system.build.toplevel} $out/system
        ln -s ${pkgs.writeScript "run-nixos-vm" startVM} $out/bin/run-${vmName}-vm
      '';

    # When building a regular system configuration, override whatever
    # video driver the host uses.
    services.xserver.videoDrivers = mkVMOverride [ "modesetting" ];
    services.xserver.defaultDepth = mkVMOverride 0;
    services.xserver.resolutions = mkVMOverride [ { x = 1024; y = 768; } ];
    services.xserver.monitorSection =
      ''
        # Set a higher refresh rate so that resolutions > 800x600 work.
        HorizSync 30-140
        VertRefresh 50-160
      '';

    # Wireless won't work in the VM.
    networking.wireless.enable = mkVMOverride false;
    networking.connman.enable = mkVMOverride false;

    # Speed up booting by not waiting for ARP.
    networking.dhcpcd.extraConfig = "noarp";

    networking.usePredictableInterfaceNames = false;

    system.requiredKernelConfig = with config.lib.kernelConfig;
      [ (isEnabled "VIRTIO_BLK")
        (isEnabled "VIRTIO_PCI")
        (isEnabled "VIRTIO_NET")
        (isEnabled "EXT4_FS")
        (isYes "BLK_DEV")
        (isYes "PCI")
        (isYes "EXPERIMENTAL")
        (isYes "NETDEVICES")
        (isYes "NET_CORE")
        (isYes "INET")
        (isYes "NETWORK_FILESYSTEMS")
      ] ++ optional (!cfg.graphics) [
        (isYes "SERIAL_8250_CONSOLE")
        (isYes "SERIAL_8250")
      ];

  };
}
