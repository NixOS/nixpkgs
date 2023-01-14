# This module creates a virtual machine from the NixOS configuration.
# Building the `config.system.build.vm' attribute gives you a command
# that starts a KVM/QEMU VM running the NixOS configuration defined in
# `config'.  The Nix store is shared read-only with the host, which
# makes (re)building VMs very efficient.  However, it also means you
# can't reconfigure the guest inside the guest - you need to rebuild
# the VM in the host.  On the other hand, the root filesystem is a
# read/writable disk image persistent across VM reboots.

{ config, lib, pkgs, options, ... }:

with lib;

let

  qemu-common = import ../../lib/qemu-common.nix { inherit lib pkgs; };

  cfg = config.virtualisation;

  opt = options.virtualisation;

  qemu = cfg.qemu.package;

  consoles = lib.concatMapStringsSep " " (c: "console=${c}") cfg.qemu.consoles;

  driveOpts = { ... }: {

    options = {

      file = mkOption {
        type = types.str;
        description = lib.mdDoc "The file image used for this drive.";
      };

      driveExtraOpts = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = lib.mdDoc "Extra options passed to drive flag.";
      };

      deviceExtraOpts = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = lib.mdDoc "Extra options passed to device flag.";
      };

      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description =
          lib.mdDoc "A name for the drive. Must be unique in the drives list. Not passed to qemu.";
      };

    };

  };

  driveCmdline = idx: { file, driveExtraOpts, deviceExtraOpts, ... }:
    let
      drvId = "drive${toString idx}";
      mkKeyValue = generators.mkKeyValueDefault {} "=";
      mkOpts = opts: concatStringsSep "," (mapAttrsToList mkKeyValue opts);
      driveOpts = mkOpts (driveExtraOpts // {
        index = idx;
        id = drvId;
        "if" = "none";
        inherit file;
      });
      deviceOpts = mkOpts (deviceExtraOpts // {
        drive = drvId;
      });
      device =
        if cfg.qemu.diskInterface == "scsi" then
          "-device lsi53c895a -device scsi-hd,${deviceOpts}"
        else
          "-device virtio-blk-pci,${deviceOpts}";
    in
      "-drive ${driveOpts} ${device}";

  drivesCmdLine = drives: concatStringsSep "\\\n    " (imap1 driveCmdline drives);


  # Creates a device name from a 1-based a numerical index, e.g.
  # * `driveDeviceName 1` -> `/dev/vda`
  # * `driveDeviceName 2` -> `/dev/vdb`
  driveDeviceName = idx:
    let letter = elemAt lowerChars (idx - 1);
    in if cfg.qemu.diskInterface == "scsi" then
      "/dev/sd${letter}"
    else
      "/dev/vd${letter}";

  lookupDriveDeviceName = driveName: driveList:
    (findSingle (drive: drive.name == driveName)
      (throw "Drive ${driveName} not found")
      (throw "Multiple drives named ${driveName}") driveList).device;

  addDeviceNames =
    imap1 (idx: drive: drive // { device = driveDeviceName idx; });


  # Shell script to start the VM.
  startVM =
    ''
      #! ${cfg.host.pkgs.runtimeShell}

      export PATH=${makeBinPath [ cfg.host.pkgs.coreutils ]}''${PATH:+:}$PATH

      set -e

      NIX_DISK_IMAGE=$(readlink -f "''${NIX_DISK_IMAGE:-${config.virtualisation.diskImage}}")

      if ! test -e "$NIX_DISK_IMAGE"; then
          ${qemu}/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" \
            ${toString config.virtualisation.diskSize}M
      fi

      # Create a directory for storing temporary data of the running VM.
      if [ -z "$TMPDIR" ] || [ -z "$USE_TMPDIR" ]; then
          TMPDIR=$(mktemp -d nix-vm.XXXXXXXXXX --tmpdir)
      fi

      ${lib.optionalString (cfg.useNixStoreImage)
        (if cfg.writableStore
          then ''
            # Create a writable copy/snapshot of the store image.
            ${qemu}/bin/qemu-img create -f qcow2 -F qcow2 -b ${storeImage}/nixos.qcow2 "$TMPDIR"/store.img
          ''
          else ''
            (
              cd ${builtins.storeDir}
              ${pkgs.erofs-utils}/bin/mkfs.erofs \
                --force-uid=0 \
                --force-gid=0 \
                -U eb176051-bd15-49b7-9e6b-462e0b467019 \
                -T 0 \
                --exclude-regex="$(
                  <${pkgs.closureInfo { rootPaths = [ config.system.build.toplevel regInfo ]; }}/store-paths \
                    sed -e 's^.*/^^g' \
                  | cut -c -10 \
                  | ${pkgs.python3}/bin/python ${./includes-to-excludes.py} )" \
                "$TMPDIR"/store.img \
                . \
                </dev/null >/dev/null
            )
          ''
        )
      }

      # Create a directory for exchanging data with the VM.
      mkdir -p "$TMPDIR/xchg"

      ${lib.optionalString cfg.useBootLoader
      ''
        # Create a writable copy/snapshot of the boot disk.
        # A writable boot disk can be booted from automatically.
        ${qemu}/bin/qemu-img create -f qcow2 -F qcow2 -b ${bootDisk}/disk.img "$TMPDIR/disk.img"

        NIX_EFI_VARS=$(readlink -f "''${NIX_EFI_VARS:-${cfg.efiVars}}")

        ${lib.optionalString cfg.useEFIBoot
        ''
          # VM needs writable EFI vars
          if ! test -e "$NIX_EFI_VARS"; then
            cp ${bootDisk}/efi-vars.fd "$NIX_EFI_VARS"
            chmod 0644 "$NIX_EFI_VARS"
          fi
        ''}
      ''}

      cd "$TMPDIR"

      ${lib.optionalString (cfg.emptyDiskImages != []) "idx=0"}
      ${flip concatMapStrings cfg.emptyDiskImages (size: ''
        if ! test -e "empty$idx.qcow2"; then
            ${qemu}/bin/qemu-img create -f qcow2 "empty$idx.qcow2" "${toString size}M"
        fi
        idx=$((idx + 1))
      '')}

      # Start QEMU.
      exec ${qemu-common.qemuBinary qemu} \
          -name ${config.system.name} \
          -m ${toString config.virtualisation.memorySize} \
          -smp ${toString config.virtualisation.cores} \
          -device virtio-rng-pci \
          ${concatStringsSep " " config.virtualisation.qemu.networkingOptions} \
          ${concatStringsSep " \\\n    "
            (mapAttrsToList
              (tag: share: "-virtfs local,path=${share.source},security_model=none,mount_tag=${tag}")
              config.virtualisation.sharedDirectories)} \
          ${drivesCmdLine config.virtualisation.qemu.drives} \
          ${concatStringsSep " \\\n    " config.virtualisation.qemu.options} \
          $QEMU_OPTS \
          "$@"
    '';


  regInfo = pkgs.closureInfo { rootPaths = config.virtualisation.additionalPaths; };


  # Generate a hard disk image containing a /boot partition and GRUB
  # in the MBR.  Used when the `useBootLoader' option is set.
  # Uses `runInLinuxVM` to create the image in a throwaway VM.
  # See note [Disk layout with `useBootLoader`].
  # FIXME: use nixos/lib/make-disk-image.nix.
  bootDisk =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "nixos-boot-disk"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/disk.img
              ${qemu}/bin/qemu-img create -f qcow2 $diskImage "60M"
              ${if cfg.useEFIBoot then ''
                efiVars=$out/efi-vars.fd
                cp ${cfg.efi.variables} $efiVars
                chmod 0644 $efiVars
              '' else ""}
            '';
          buildInputs = [ pkgs.util-linux ];
          QEMU_OPTS = "-nographic -serial stdio -monitor none"
                      + lib.optionalString cfg.useEFIBoot (
                        " -drive if=pflash,format=raw,unit=0,readonly=on,file=${cfg.efi.firmware}"
                      + " -drive if=pflash,format=raw,unit=1,file=$efiVars");
        }
        ''
          # Create a /boot EFI partition with 60M and arbitrary but fixed GUIDs for reproducibility
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

          ${optionalString (config.boot.loader.grub.device != "/dev/vda")
            # In this throwaway VM, we only have the /dev/vda disk, but the
            # actual VM described by `config` (used by `switch-to-configuration`
            # below) may set `boot.loader.grub.device` to a different device
            # that's nonexistent in the throwaway VM.
            # Create a symlink for that device, so that the `grub-install`
            # by `switch-to-configuration` will hit /dev/vda anyway.
            ''
              ln -s /dev/vda ${config.boot.loader.grub.device}
            ''
          }

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

          ${optionalString config.boot.loader.efi.canTouchEfiVariables ''
            mount -t efivarfs efivarfs /sys/firmware/efi/efivars
          ''}

          # This is needed for GRUB 0.97, which doesn't know about virtio devices.
          mkdir /boot/grub
          echo '(hd0) /dev/vda' > /boot/grub/device.map

          # This is needed for systemd-boot to find ESP, and udev is not available here to create this
          mkdir -p /dev/block
          ln -s /dev/vda2 /dev/block/254:2

          # Set up system profile (normally done by nixos-rebuild / nix-env --set)
          mkdir -p /nix/var/nix/profiles
          ln -s ${config.system.build.toplevel} /nix/var/nix/profiles/system-1-link
          ln -s /nix/var/nix/profiles/system-1-link /nix/var/nix/profiles/system

          # Install bootloader
          touch /etc/NIXOS
          export NIXOS_INSTALL_BOOTLOADER=1
          ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /boot
        '' # */
    );

  storeImage = import ../../lib/make-disk-image.nix {
    inherit pkgs config lib;
    additionalPaths = [ regInfo ];
    format = "qcow2";
    onlyNixStore = true;
    partitionTableType = "none";
    installBootLoader = false;
    diskSize = "auto";
    additionalSpace = "0M";
    copyChannel = false;
  };

in

{
  imports = [
    ../profiles/qemu-guest.nix
    (mkRenamedOptionModule [ "virtualisation" "pathsInNixDB" ] [ "virtualisation" "additionalPaths" ])
  ];

  options = {

    virtualisation.fileSystems = options.fileSystems;

    virtualisation.memorySize =
      mkOption {
        type = types.ints.positive;
        default = 1024;
        description =
          lib.mdDoc ''
            The memory size in megabytes of the virtual machine.
          '';
      };

    virtualisation.msize =
      mkOption {
        type = types.ints.positive;
        default = 16384;
        description =
          lib.mdDoc ''
            The msize (maximum packet size) option passed to 9p file systems, in
            bytes. Increasing this should increase performance significantly,
            at the cost of higher RAM usage.
          '';
      };

    virtualisation.diskSize =
      mkOption {
        type = types.nullOr types.ints.positive;
        default = 1024;
        description =
          lib.mdDoc ''
            The disk size in megabytes of the virtual machine.
          '';
      };

    virtualisation.diskImage =
      mkOption {
        type = types.str;
        default = "./${config.system.name}.qcow2";
        defaultText = literalExpression ''"./''${config.system.name}.qcow2"'';
        description =
          lib.mdDoc ''
            Path to the disk image containing the root filesystem.
            The image will be created on startup if it does not
            exist.
          '';
      };

    virtualisation.bootDevice =
      mkOption {
        type = types.path;
        example = "/dev/vda";
        description =
          lib.mdDoc ''
            The disk to be used for the root filesystem.
          '';
      };

    virtualisation.emptyDiskImages =
      mkOption {
        type = types.listOf types.ints.positive;
        default = [];
        description =
          lib.mdDoc ''
            Additional disk images to provide to the VM. The value is
            a list of size in megabytes of each disk. These disks are
            writeable by the VM.
          '';
      };

    virtualisation.graphics =
      mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc ''
            Whether to run QEMU with a graphics window, or in nographic mode.
            Serial console will be enabled on both settings, but this will
            change the preferred console.
            '';
      };

    virtualisation.resolution =
      mkOption {
        type = options.services.xserver.resolutions.type.nestedTypes.elemType;
        default = { x = 1024; y = 768; };
        description =
          lib.mdDoc ''
            The resolution of the virtual machine display.
          '';
      };

    virtualisation.cores =
      mkOption {
        type = types.ints.positive;
        default = 1;
        description =
          lib.mdDoc ''
            Specify the number of cores the guest is permitted to use.
            The number can be higher than the available cores on the
            host system.
          '';
      };

    virtualisation.sharedDirectories =
      mkOption {
        type = types.attrsOf
          (types.submodule {
            options.source = mkOption {
              type = types.str;
              description = lib.mdDoc "The path of the directory to share, can be a shell variable";
            };
            options.target = mkOption {
              type = types.path;
              description = lib.mdDoc "The mount point of the directory inside the virtual machine";
            };
          });
        default = { };
        example = {
          my-share = { source = "/path/to/be/shared"; target = "/mnt/shared"; };
        };
        description =
          lib.mdDoc ''
            An attributes set of directories that will be shared with the
            virtual machine using VirtFS (9P filesystem over VirtIO).
            The attribute name will be used as the 9P mount tag.
          '';
      };

    virtualisation.additionalPaths =
      mkOption {
        type = types.listOf types.path;
        default = [];
        description =
          lib.mdDoc ''
            A list of paths whose closure should be made available to
            the VM.

            When 9p is used, the closure is registered in the Nix
            database in the VM. All other paths in the host Nix store
            appear in the guest Nix store as well, but are considered
            garbage (because they are not registered in the Nix
            database of the guest).

            When {option}`virtualisation.useNixStoreImage` is
            set, the closure is copied to the Nix store image.
          '';
      };

    virtualisation.forwardPorts = mkOption {
      type = types.listOf
        (types.submodule {
          options.from = mkOption {
            type = types.enum [ "host" "guest" ];
            default = "host";
            description =
              lib.mdDoc ''
                Controls the direction in which the ports are mapped:

                - `"host"` means traffic from the host ports
                  is forwarded to the given guest port.
                - `"guest"` means traffic from the guest ports
                  is forwarded to the given host port.
              '';
          };
          options.proto = mkOption {
            type = types.enum [ "tcp" "udp" ];
            default = "tcp";
            description = lib.mdDoc "The protocol to forward.";
          };
          options.host.address = mkOption {
            type = types.str;
            default = "";
            description = lib.mdDoc "The IPv4 address of the host.";
          };
          options.host.port = mkOption {
            type = types.port;
            description = lib.mdDoc "The host port to be mapped.";
          };
          options.guest.address = mkOption {
            type = types.str;
            default = "";
            description = lib.mdDoc "The IPv4 address on the guest VLAN.";
          };
          options.guest.port = mkOption {
            type = types.port;
            description = lib.mdDoc "The guest port to be mapped.";
          };
        });
      default = [];
      example = lib.literalExpression
        ''
        [ # forward local port 2222 -> 22, to ssh into the VM
          { from = "host"; host.port = 2222; guest.port = 22; }

          # forward local port 80 -> 10.0.2.10:80 in the VLAN
          { from = "guest";
            guest.address = "10.0.2.10"; guest.port = 80;
            host.address = "127.0.0.1"; host.port = 80;
          }
        ]
        '';
      description =
        lib.mdDoc ''
          When using the SLiRP user networking (default), this option allows to
          forward ports to/from the host/guest.

          ::: {.warning}
          If the NixOS firewall on the virtual machine is enabled, you also
          have to open the guest ports to enable the traffic between host and
          guest.
          :::

          ::: {.note}
          Currently QEMU supports only IPv4 forwarding.
          :::
        '';
    };

    virtualisation.restrictNetwork =
      mkOption {
        type = types.bool;
        default = false;
        example = true;
        description =
          lib.mdDoc ''
            If this option is enabled, the guest will be isolated, i.e. it will
            not be able to contact the host and no guest IP packets will be
            routed over the host to the outside. This option does not affect
            any explicitly set forwarding rules.
          '';
      };

    virtualisation.vlans =
      mkOption {
        type = types.listOf types.ints.unsigned;
        default = [ 1 ];
        example = [ 1 2 ];
        description =
          lib.mdDoc ''
            Virtual networks to which the VM is connected.  Each
            number «N» in this list causes
            the VM to have a virtual Ethernet interface attached to a
            separate virtual network on which it will be assigned IP
            address
            `192.168.«N».«M»`,
            where «M» is the index of this VM
            in the list of VMs.
          '';
      };

    virtualisation.writableStore =
      mkOption {
        type = types.bool;
        default = true; # FIXME
        description =
          lib.mdDoc ''
            If enabled, the Nix store in the VM is made writable by
            layering an overlay filesystem on top of the host's Nix
            store.
          '';
      };

    virtualisation.writableStoreUseTmpfs =
      mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc ''
            Use a tmpfs for the writable store instead of writing to the VM's
            own filesystem.
          '';
      };

    networking.primaryIPAddress =
      mkOption {
        type = types.str;
        default = "";
        internal = true;
        description = lib.mdDoc "Primary IP address used in /etc/hosts.";
      };

    virtualisation.host.pkgs = mkOption {
      type = options.nixpkgs.pkgs.type;
      default = pkgs;
      defaultText = literalExpression "pkgs";
      example = literalExpression ''
        import pkgs.path { system = "x86_64-darwin"; }
      '';
      description = lib.mdDoc ''
        pkgs set to use for the host-specific packages of the vm runner.
        Changing this to e.g. a Darwin package set allows running NixOS VMs on Darwin.
      '';
    };

    virtualisation.qemu = {
      package =
        mkOption {
          type = types.package;
          default = cfg.host.pkgs.qemu_kvm;
          defaultText = literalExpression "config.virtualisation.host.pkgs.qemu_kvm";
          example = literalExpression "pkgs.qemu_test";
          description = lib.mdDoc "QEMU package to use.";
        };

      options =
        mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "-vga std" ];
          description = lib.mdDoc "Options passed to QEMU.";
        };

      consoles = mkOption {
        type = types.listOf types.str;
        default = let
          consoles = [ "${qemu-common.qemuSerialDevice},115200n8" "tty0" ];
        in if cfg.graphics then consoles else reverseList consoles;
        example = [ "console=tty1" ];
        description = lib.mdDoc ''
          The output console devices to pass to the kernel command line via the
          `console` parameter, the primary console is the last
          item of this list.

          By default it enables both serial console and
          `tty0`. The preferred console (last one) is based on
          the value of {option}`virtualisation.graphics`.
        '';
      };

      networkingOptions =
        mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "-net nic,netdev=user.0,model=virtio"
            "-netdev user,id=user.0,\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
          ];
          description = lib.mdDoc ''
            Networking-related command-line options that should be passed to qemu.
            The default is to use userspace networking (SLiRP).

            If you override this option, be advised to keep
            ''${QEMU_NET_OPTS:+,$QEMU_NET_OPTS} (as seen in the example)
            to keep the default runtime behaviour.
          '';
        };

      drives =
        mkOption {
          type = types.listOf (types.submodule driveOpts);
          description = lib.mdDoc "Drives passed to qemu.";
          apply = addDeviceNames;
        };

      diskInterface =
        mkOption {
          type = types.enum [ "virtio" "scsi" "ide" ];
          default = "virtio";
          example = "scsi";
          description = lib.mdDoc "The interface used for the virtual hard disks.";
        };

      guestAgent.enable =
        mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Enable the Qemu guest agent.
          '';
        };

      virtioKeyboard =
        mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Enable the virtio-keyboard device.
          '';
        };
    };

    virtualisation.useNixStoreImage =
      mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Build and use a disk image for the Nix store, instead of
          accessing the host's one through 9p.

          For applications which do a lot of reads from the store,
          this can drastically improve performance, but at the cost of
          disk space and image build time.
        '';
      };

    virtualisation.useBootLoader =
      mkOption {
        type = types.bool;
        default = false;
        description =
          lib.mdDoc ''
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
        type = types.bool;
        default = false;
        description =
          lib.mdDoc ''
            If enabled, the virtual machine will provide a EFI boot
            manager.
            useEFIBoot is ignored if useBootLoader == false.
          '';
        };

    virtualisation.efi = {
      firmware = mkOption {
        type = types.path;
        default = pkgs.OVMF.firmware;
        defaultText = literalExpression "pkgs.OVMF.firmware";
        description =
          lib.mdDoc ''
            Firmware binary for EFI implementation, defaults to OVMF.
          '';
      };

      variables = mkOption {
        type = types.path;
        default = pkgs.OVMF.variables;
        defaultText = literalExpression "pkgs.OVMF.variables";
        description =
          lib.mdDoc ''
            Platform-specific flash binary for EFI variables, implementation-dependent to the EFI firmware.
            Defaults to OVMF.
          '';
      };
    };

    virtualisation.useDefaultFilesystems =
      mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc ''
            If enabled, the boot disk of the virtual machine will be
            formatted and mounted with the default filesystems for
            testing. Swap devices and LUKS will be disabled.

            If disabled, a root filesystem has to be specified and
            formatted (for example in the initial ramdisk).
          '';
      };

    virtualisation.efiVars =
      mkOption {
        type = types.str;
        default = "./${config.system.name}-efi-vars.fd";
        defaultText = literalExpression ''"./''${config.system.name}-efi-vars.fd"'';
        description =
          lib.mdDoc ''
            Path to nvram image containing UEFI variables.  The will be created
            on startup if it does not exist.
          '';
      };

    virtualisation.bios =
      mkOption {
        type = types.nullOr types.package;
        default = null;
        description =
          lib.mdDoc ''
            An alternate BIOS (such as `qboot`) with which to start the VM.
            Should contain a file named `bios.bin`.
            If `null`, QEMU's builtin SeaBIOS will be used.
          '';
      };

  };

  config = {

    assertions =
      lib.concatLists (lib.flip lib.imap cfg.forwardPorts (i: rule:
        [
          { assertion = rule.from == "guest" -> rule.proto == "tcp";
            message =
              ''
                Invalid virtualisation.forwardPorts.<entry ${toString i}>.proto:
                  Guest forwarding supports only TCP connections.
              '';
          }
          { assertion = rule.from == "guest" -> lib.hasPrefix "10.0.2." rule.guest.address;
            message =
              ''
                Invalid virtualisation.forwardPorts.<entry ${toString i}>.guest.address:
                  The address must be in the default VLAN (10.0.2.0/24).
              '';
          }
        ]));

    warnings =
      optional (
        cfg.writableStore &&
        cfg.useNixStoreImage &&
        opt.writableStore.highestPrio > lib.modules.defaultOverridePriority)
        ''
          You have enabled ${opt.useNixStoreImage} = true,
          without setting ${opt.writableStore} = false.

          This causes a store image to be written to the store, which is
          costly, especially for the binary cache, and because of the need
          for more frequent garbage collection.

          If you really need this combination, you can set ${opt.writableStore}
          explicitly to true, incur the cost and make this warning go away.
          Otherwise, we recommend

            ${opt.writableStore} = false;
        '';

    # Note [Disk layout with `useBootLoader`]
    #
    # If `useBootLoader = true`, we configure 2 drives:
    # `/dev/?da` for the root disk, and `/dev/?db` for the boot disk
    # which has the `/boot` partition and the boot loader.
    # Concretely:
    #
    # * The second drive's image `disk.img` is created in `bootDisk = ...`
    #   using a throwaway VM. Note that there the disk is always `/dev/vda`,
    #   even though in the final VM it will be at `/dev/*b`.
    # * The disks are attached in `virtualisation.qemu.drives`.
    #   Their order makes them appear as devices `a`, `b`, etc.
    # * `fileSystems."/boot"` is adjusted to be on device `b`.

    # If `useBootLoader`, GRUB goes to the second disk, see
    # note [Disk layout with `useBootLoader`].
    boot.loader.grub.device = mkVMOverride (
      if cfg.useBootLoader
        then driveDeviceName 2 # second disk
        else cfg.bootDevice
    );
    boot.loader.grub.gfxmodeBios = with cfg.resolution; "${toString x}x${toString y}";

    boot.initrd.kernelModules = optionals (cfg.useNixStoreImage && !cfg.writableStore) [ "erofs" ];

    boot.initrd.extraUtilsCommands = lib.mkIf (cfg.useDefaultFilesystems && !config.boot.initrd.systemd.enable)
      ''
        # We need mke2fs in the initrd.
        copy_bin_and_libs ${pkgs.e2fsprogs}/bin/mke2fs
      '';

    boot.initrd.postDeviceCommands = lib.mkIf (cfg.useDefaultFilesystems && !config.boot.initrd.systemd.enable)
      ''
        # If the disk image appears to be empty, run mke2fs to
        # initialise.
        FSTYPE=$(blkid -o value -s TYPE ${cfg.bootDevice} || true)
        PARTTYPE=$(blkid -o value -s PTTYPE ${cfg.bootDevice} || true)
        if test -z "$FSTYPE" -a -z "$PARTTYPE"; then
            mke2fs -t ext4 ${cfg.bootDevice}
        fi
      '';

    boot.initrd.postMountCommands = lib.mkIf (!config.boot.initrd.systemd.enable)
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

    systemd.tmpfiles.rules = lib.mkIf config.boot.initrd.systemd.enable [
      "f /etc/NIXOS 0644 root root -"
      "d /boot 0644 root root -"
    ];

    # After booting, register the closure of the paths in
    # `virtualisation.additionalPaths' in the Nix database in the VM.  This
    # allows Nix operations to work in the VM.  The path to the
    # registration file is passed through the kernel command line to
    # allow `system.build.toplevel' to be included.  (If we had a direct
    # reference to ${regInfo} here, then we would get a cyclic
    # dependency.)
    boot.postBootCommands = lib.mkIf config.nix.enable
      ''
        if [[ "$(cat /proc/cmdline)" =~ regInfo=([^ ]*) ]]; then
          ${config.nix.package.out}/bin/nix-store --load-db < ''${BASH_REMATCH[1]}
        fi
      '';

    boot.initrd.availableKernelModules =
      optional cfg.writableStore "overlay"
      ++ optional (cfg.qemu.diskInterface == "scsi") "sym53c8xx";

    virtualisation.bootDevice = mkDefault (driveDeviceName 1);

    virtualisation.additionalPaths = [ config.system.build.toplevel ];

    virtualisation.sharedDirectories = {
      nix-store = mkIf (!cfg.useNixStoreImage) {
        source = builtins.storeDir;
        target = "/nix/store";
      };
      xchg = {
        source = ''"$TMPDIR"/xchg'';
        target = "/tmp/xchg";
      };
      shared = {
        source = ''"''${SHARED_DIR:-$TMPDIR/xchg}"'';
        target = "/tmp/shared";
      };
    };

    virtualisation.qemu.networkingOptions =
      let
        forwardingOptions = flip concatMapStrings cfg.forwardPorts
          ({ proto, from, host, guest }:
            if from == "host"
              then "hostfwd=${proto}:${host.address}:${toString host.port}-" +
                   "${guest.address}:${toString guest.port},"
              else "'guestfwd=${proto}:${guest.address}:${toString guest.port}-" +
                   "cmd:${pkgs.netcat}/bin/nc ${host.address} ${toString host.port}',"
          );
        restrictNetworkOption = lib.optionalString cfg.restrictNetwork "restrict=on,";
      in
      [
        "-net nic,netdev=user.0,model=virtio"
        "-netdev user,id=user.0,${forwardingOptions}${restrictNetworkOption}\"$QEMU_NET_OPTS\""
      ];

    # FIXME: Consolidate this one day.
    virtualisation.qemu.options = mkMerge [
      (mkIf cfg.qemu.virtioKeyboard [
        "-device virtio-keyboard"
      ])
      (mkIf pkgs.stdenv.hostPlatform.isx86 [
        "-usb" "-device usb-tablet,bus=usb-bus.0"
      ])
      (mkIf pkgs.stdenv.hostPlatform.isAarch [
        "-device virtio-gpu-pci" "-device usb-ehci,id=usb0" "-device usb-kbd" "-device usb-tablet"
      ])
      (let
        alphaNumericChars = lowerChars ++ upperChars ++ (map toString (range 0 9));
        # Replace all non-alphanumeric characters with underscores
        sanitizeShellIdent = s: concatMapStrings (c: if builtins.elem c alphaNumericChars then c else "_") (stringToCharacters s);
      in mkIf (!cfg.useBootLoader) [
        "-kernel \${NIXPKGS_QEMU_KERNEL_${sanitizeShellIdent config.system.name}:-${config.system.build.toplevel}/kernel}"
        "-initrd ${config.system.build.toplevel}/initrd"
        ''-append "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.toplevel}/init regInfo=${regInfo}/registration ${consoles} $QEMU_KERNEL_PARAMS"''
      ])
      (mkIf cfg.useEFIBoot [
        "-drive if=pflash,format=raw,unit=0,readonly=on,file=${cfg.efi.firmware}"
        "-drive if=pflash,format=raw,unit=1,file=$NIX_EFI_VARS"
      ])
      (mkIf (cfg.bios != null) [
        "-bios ${cfg.bios}/bios.bin"
      ])
      (mkIf (!cfg.graphics) [
        "-nographic"
      ])
    ];

    virtualisation.qemu.drives = mkMerge [
      [{
        name = "root";
        file = ''"$NIX_DISK_IMAGE"'';
        driveExtraOpts.cache = "writeback";
        driveExtraOpts.werror = "report";
      }]
      (mkIf cfg.useNixStoreImage [{
        name = "nix-store";
        file = ''"$TMPDIR"/store.img'';
        deviceExtraOpts.bootindex = if cfg.useBootLoader then "3" else "2";
        driveExtraOpts.format = if cfg.writableStore then "qcow2" else "raw";
      }])
      (mkIf cfg.useBootLoader [
        # The order of this list determines the device names, see
        # note [Disk layout with `useBootLoader`].
        {
          name = "boot";
          file = ''"$TMPDIR"/disk.img'';
          driveExtraOpts.media = "disk";
          deviceExtraOpts.bootindex = "1";
        }
      ])
      (imap0 (idx: _: {
        file = "$(pwd)/empty${toString idx}.qcow2";
        driveExtraOpts.werror = "report";
      }) cfg.emptyDiskImages)
    ];

    # Mount the host filesystem via 9P, and bind-mount the Nix store
    # of the host into our own filesystem.  We use mkVMOverride to
    # allow this module to be applied to "normal" NixOS system
    # configuration, where the regular value for the `fileSystems'
    # attribute should be disregarded for the purpose of building a VM
    # test image (since those filesystems don't exist in the VM).
    fileSystems =
    let
      mkSharedDir = tag: share:
        {
          name =
            if tag == "nix-store" && cfg.writableStore
              then "/nix/.ro-store"
              else share.target;
          value.device = tag;
          value.fsType = "9p";
          value.neededForBoot = true;
          value.options =
            [ "trans=virtio" "version=9p2000.L"  "msize=${toString cfg.msize}" ]
            ++ lib.optional (tag == "nix-store") "cache=loose";
        };
    in
      mkVMOverride (cfg.fileSystems //
      optionalAttrs cfg.useDefaultFilesystems {
        "/".device = cfg.bootDevice;
        "/".fsType = "ext4";
        "/".autoFormat = true;
      } //
      optionalAttrs config.boot.tmpOnTmpfs {
        "/tmp" = {
          device = "tmpfs";
          fsType = "tmpfs";
          neededForBoot = true;
          # Sync with systemd's tmp.mount;
          options = [ "mode=1777" "strictatime" "nosuid" "nodev" "size=${toString config.boot.tmpOnTmpfsSize}" ];
        };
      } //
      optionalAttrs cfg.useNixStoreImage {
        "/nix/${if cfg.writableStore then ".ro-store" else "store"}" = {
          device = "${lookupDriveDeviceName "nix-store" cfg.qemu.drives}";
          neededForBoot = true;
          options = [ "ro" ];
        };
      } //
      optionalAttrs (cfg.writableStore && cfg.writableStoreUseTmpfs) {
        "/nix/.rw-store" = {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
          neededForBoot = true;
        };
      } //
      optionalAttrs cfg.useBootLoader {
        # see note [Disk layout with `useBootLoader`]
        "/boot" = {
          device = "${lookupDriveDeviceName "boot" cfg.qemu.drives}2"; # 2 for e.g. `vdb2`, as created in `bootDisk`
          fsType = "vfat";
          noCheck = true; # fsck fails on a r/o filesystem
        };
      } // lib.mapAttrs' mkSharedDir cfg.sharedDirectories);

    boot.initrd.systemd = lib.mkIf (config.boot.initrd.systemd.enable && cfg.writableStore) {
      mounts = [{
        where = "/sysroot/nix/store";
        what = "overlay";
        type = "overlay";
        options = "lowerdir=/sysroot/nix/.ro-store,upperdir=/sysroot/nix/.rw-store/store,workdir=/sysroot/nix/.rw-store/work";
        wantedBy = ["local-fs.target"];
        before = ["local-fs.target"];
        requires = ["sysroot-nix-.ro\\x2dstore.mount" "sysroot-nix-.rw\\x2dstore.mount" "rw-store.service"];
        after = ["sysroot-nix-.ro\\x2dstore.mount" "sysroot-nix-.rw\\x2dstore.mount" "rw-store.service"];
        unitConfig.IgnoreOnIsolate = true;
      }];
      services.rw-store = {
        after = ["sysroot-nix-.rw\\x2dstore.mount"];
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "/bin/mkdir -p 0755 /sysroot/nix/.rw-store/store /sysroot/nix/.rw-store/work /sysroot/nix/store";
        };
      };
    };

    swapDevices = (if cfg.useDefaultFilesystems then mkVMOverride else mkDefault) [ ];
    boot.initrd.luks.devices = (if cfg.useDefaultFilesystems then mkVMOverride else mkDefault) {};

    # Don't run ntpd in the guest.  It should get the correct time from KVM.
    services.timesyncd.enable = false;

    services.qemuGuest.enable = cfg.qemu.guestAgent.enable;

    system.build.vm = cfg.host.pkgs.runCommand "nixos-vm" {
      preferLocalBuild = true;
      meta.mainProgram = "run-${config.system.name}-vm";
    }
      ''
        mkdir -p $out/bin
        ln -s ${config.system.build.toplevel} $out/system
        ln -s ${cfg.host.pkgs.writeScript "run-nixos-vm" startVM} $out/bin/run-${config.system.name}-vm
      '';

    # When building a regular system configuration, override whatever
    # video driver the host uses.
    services.xserver.videoDrivers = mkVMOverride [ "modesetting" ];
    services.xserver.defaultDepth = mkVMOverride 0;
    services.xserver.resolutions = mkVMOverride [ cfg.resolution ];
    services.xserver.monitorSection =
      ''
        # Set a higher refresh rate so that resolutions > 800x600 work.
        HorizSync 30-140
        VertRefresh 50-160
      '';

    # Wireless won't work in the VM.
    networking.wireless.enable = mkVMOverride false;
    services.connman.enable = mkVMOverride false;

    # Speed up booting by not waiting for ARP.
    networking.dhcpcd.extraConfig = "noarp";

    networking.usePredictableInterfaceNames = false;

    system.requiredKernelConfig = with config.lib.kernelConfig;
      [ (isEnabled "VIRTIO_BLK")
        (isEnabled "VIRTIO_PCI")
        (isEnabled "VIRTIO_NET")
        (isEnabled "EXT4_FS")
        (isEnabled "NET_9P_VIRTIO")
        (isEnabled "9P_FS")
        (isYes "BLK_DEV")
        (isYes "PCI")
        (isYes "NETDEVICES")
        (isYes "NET_CORE")
        (isYes "INET")
        (isYes "NETWORK_FILESYSTEMS")
      ] ++ optionals (!cfg.graphics) [
        (isYes "SERIAL_8250_CONSOLE")
        (isYes "SERIAL_8250")
      ] ++ optionals (cfg.writableStore) [
        (isEnabled "OVERLAY_FS")
      ];

  };

  # uses types of services/x11/xserver.nix
  meta.buildDocsInSandbox = false;
}
