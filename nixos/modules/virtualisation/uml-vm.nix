{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation;
  hostPkgs = cfg.host.pkgs;
  driveOpts =
    { ... }:
    {
      options = {
        file = lib.mkOption {
          type = lib.types.str;
          description = "The file image used for this drive";
        };

        backingFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "./backing-file";
          description = "The backing file used for the COW image";
        };

        serial = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The serial number for the ubd device";
        };

        read-only = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Open ubd file read only";
        };

        sync = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Open ubd files with the sync option set, this makes the host save changes to the disk as they are written";
        };

        no-cow = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Ignore COW detection and open the drive directly";
        };

        shared = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Treat the file as being shared between multiple instances and disable file locking";
        };

        no-trim = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Disable trim/discard support on the device";
        };
      };
    };

  # Descriptions are from https://docs.kernel.org/virt/uml/user_mode_linux_howto_v2.html#common-options
  netOpts =
    { config, ... }:
    {
      options = {
        options = lib.mkOption {
          type = lib.types.commas;
          description = "Vector transport options";
        };
        transport = lib.mkOption {
          type = lib.types.str;
          description = "The vector transport name";
        };
        depth = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Sets the queue depth for vector IO. This is the amount of packets UML will attempt to read or write in a single system call. The default number is 64 and is generally sufficient for most applications that need throughput in the 2-4 Gbit range. Higher speeds may require larger values.";
        };
        mac = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Sets the interface MAC address value.";
        };
        gro = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = ''
            sets GRO off or on. Enables receive/transmit offloads. The effect of
            this option depends on the host side support in the transport which
            is being configured. In most cases it will enable TCP segmentation
            and RX/TX checksumming offloads. The setting must be identical on the
            host side and the UML side. The UML kernel will produce warnings if
            it is not. For example, GRO is enabled by default on local machine
            interfaces (e.g. veth pairs, bridge, etc), so it should be enabled in
            UML in the corresponding UML transports (raw, tap, hybrid) in order
            for networking to operate correctly.
          '';
        };
        mtu = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Sets the interface MTU";
        };
        headroom = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "adjusts the default headroom (32 bytes) reserved if a packet will need to be re-encapsulated into for instance VXLAN.";
        };
        vec = lib.mkEnableOption "disable multipacket IO and fall back to packet at a time mode";
      };
      config = {
        options = lib.concatStringsSep "," (
          [
            "transport=${config.transport}"
          ]
          ++ (lib.optional (lib.isInt config.depth) "depth=${toString config.depth}")
          ++ (lib.optional (lib.isString config.mac) "mac=${config.mac}")
          ++ (lib.optional config.gro "gro=1")
          ++ (lib.optional (lib.isInt config.mtu) "mtu=${toString config.mtu}")
          ++ (lib.optional (lib.isInt config.headroom) "headroom=${toString config.headroom}")
          ++ (lib.optional config.vec "vec=0")
        );
      };
    };

  mkDriveFlags =
    drive:
    lib.concatStrings [
      (lib.optionalString drive.read-only "r")
      (lib.optionalString drive.sync "s")
      (lib.optionalString drive.no-cow "d")
      (lib.optionalString drive.shared "c")
      (lib.optionalString drive.no-trim "t")
    ];

  driveCmdline = lib.imap0 (
    index: drive:
    "ubd${toString index}${mkDriveFlags drive}=${drive.file}"
    + lib.optionalString (
      lib.isString drive.backingFile || lib.isString drive.serial
    ) ",${toString drive.backingFile}"
    + lib.optionalString (lib.isString drive.serial) ",${drive.serial}"
  ) cfg.uml.drives;

  netCmdline = lib.imap0 (index: net: "vec${toString index}:${net.options}") cfg.uml.networks;

  # Use well-defined and persistent filesystem labels to identify block devices.
  rootFilesystemLabel = "nixos";

  rootDriveSerialAttr = "root";

in

{
  options = {
    virtualisation = {
      uml = {
        drives = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule driveOpts);
          description = "The ubd drives used for User-Mode Linux";
        };
        options = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "con1=xterm" ];
          description = ''
            Command line parameters passed to the User-Mode Linux kernel
          '';
        };
        kernelPackages = options.boot.kernelPackages // {
          default = pkgs.linuxPackages_uml;
        };
        initrd = lib.mkOption {
          type = lib.types.str;
          default = "${config.system.build.toplevel}/${config.system.boot.loader.initrdFile}";
          defaultText = "\${config.system.build.initialRamdisk}/\${config.system.boot.loader.initrdFile}";
          description = ''
            When using User-Mode Linux, you may want to change the initrd
          '';
        };
        networks = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule netOpts);
          description = "The vector networks used for User-Mode Linux";
        };
      };
    };
  };
  config = {
    boot = {
      initrd = {
        allowMissingModules = true;
        availableKernelModules = [ "hostfs" ];
      };
      loader = {
        grub = {
          enable = lib.mkForce false;
        };
      };
      kernelPackages = lib.mkVMOverride cfg.uml.kernelPackages;
    };
    system = {
      boot.loader.kernelFile = "vmlinux";
      build = {
        uml-loader = hostPkgs.writeShellScriptBin "run-${config.system.name}" ''
          export PATH=${lib.makeBinPath [ hostPkgs.coreutils ]}''${PATH:+:}$PATH

          set -e

          createEmptyFilesystemImage() {
            local name=$1
            local size=$2
            ${pkgs.e2fsprogs}/bin/mkfs.ext4 -L ${rootFilesystemLabel} "$name" "$size"
          }

          NIX_DISK_IMAGE=$(readlink -f "''${NIX_DISK_IMAGE:-${toString config.virtualisation.diskImage}}") || test -z "$NIX_DISK_IMAGE"

          if test -n "$NIX_DISK_IMAGE" && ! test -e "$NIX_DISK_IMAGE"; then
            echo "Disk image does not exist, creating the virtualisation disk image..."
            ${
              if cfg.useDefaultFilesystems then
                ''
                  createEmptyFilesystemImage "$NIX_DISK_IMAGE" "${toString cfg.diskSize}M"
                ''
              else
                ''
                  fallocate -l "${toString cfg.diskSize}M" "$NIX_DISK_IMAGE"
                ''
            }
          fi

          if [ -z "$TMPDIR" ] || [ -z "$USE_TMPDIR" ]; then
            TMPDIR=(mktemp -d nix-vm.XXXXXXXXXX --tmpdir)
          fi

          export PATH=${pkgs.vde2}/bin:${pkgs.uml-utilities.lib}/lib/uml:$PATH

          export UML_PORT_HELPER=${pkgs.uml-utilities.lib}/lib/uml/port-helper

          exec ${config.system.build.toplevel}/kernel \
            ${lib.concatStringsSep " \\\n  " config.virtualisation.uml.options} \
            "$@"
        '';
      };
    };
    # Unlike a non user-mode kernel, in User-Mode Linux, tty0 (con0) is a normal console and the default
    systemd.targets.getty.wants = [ "getty@tty0.service" ];
    virtualisation = {
      fileSystems =
        lib.mapAttrs' (tag: share: {
          name = share.target;
          value = {
            fsType = lib.mkForce "hostfs";
            options = lib.mkForce [ "hostfs=${share.source}" ];
          };
        }) config.virtualisation.sharedDirectories
        // {
          "/tmp/xchg" = {
            neededForBoot = lib.mkForce false;
            options = [ "noauto" ];
          };
          "/tmp/shared" = {
            neededForBoot = lib.mkForce false;
            options = [ "noauto" ];
          };
        };
      uml = {
        drives = lib.mkMerge [
          (lib.mkIf (cfg.diskImage != null) [
            {
              serial = rootDriveSerialAttr;
              file = ''"$NIX_DISK_IMAGE"'';
            }
          ])
          (lib.mkIf cfg.useNixStoreImage [
            {
              file = ''"$TMPDIR"/store.img'';
            }
          ])
          (lib.imap0 (idx: _: {
            file = "$(pwd)/empty${toString idx}.qcow2";
          }) cfg.emptyDiskImages)
        ];
        options = [
          "initrd=${config.virtualisation.uml.initrd}"
          "mem=${toString config.virtualisation.memorySize}M"
          "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.toplevel}/init"
        ]
        ++ driveCmdline
        ++ netCmdline;
      };
    };
  };
}
