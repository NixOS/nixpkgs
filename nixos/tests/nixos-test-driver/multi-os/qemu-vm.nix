{ config, lib, name, options, pkgs, nixThePlanet, ... }:
let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;
  inherit (lib)
    concatStringsSep
    generators
    imap1
    mapAttrsToList
    mkIf
    mkMerge
    ;

  cfg = config.virtualisation;

  hostPkgs = cfg.host.pkgs;

  inherit (hostPkgs) qemu;

  qemu-common = import ../../../lib/qemu-common.nix { inherit lib pkgs; };

  driveCmdline =
    idx:
    {
      file,
      driveExtraOpts,
      deviceExtraOpts,
      ...
    }:
    let
      drvId = "drive${toString idx}";
      mkKeyValue = generators.mkKeyValueDefault { } "=";
      mkOpts = opts: concatStringsSep "," (mapAttrsToList mkKeyValue opts);
      driveOpts = mkOpts (
        driveExtraOpts
        // {
          index = idx;
          id = drvId;
          "if" = "none";
          inherit file;
        }
      );
      deviceOpts = mkOpts (
        deviceExtraOpts
        // {
          drive = drvId;
        }
      );
      device = "-device virtio-blk-pci,${deviceOpts}";
    in
    "-drive ${driveOpts} ${device}";

  rootDriveSerialAttr = "root";
  drivesCmdLine = drives: concatStringsSep "\\\n    " (imap1 driveCmdline drives);
  driveOpts =
    { ... }:
    {

      options = {

        file = mkOption {
          type = types.str;
          description = "The file image used for this drive.";
        };

        driveExtraOpts = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Extra options passed to drive flag.";
        };

        deviceExtraOpts = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Extra options passed to device flag.";
        };

        name = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "A name for the drive. Must be unique in the drives list. Not passed to qemu.";
        };

      };

    };

  startVM = ''
    #! ${hostPkgs.runtimeShell}

    set -eux -o pipefail

    # TODO: should this refer to systemImage instead?
    NIX_DISK_IMAGE=$(readlink -f "''${NIX_DISK_IMAGE:-${toString config.virtualisation.diskImage}}") || test -z "$NIX_DISK_IMAGE"

    if [[ -e root.qcow2 ]]; then
      echo root.qcow2 already exists, not creating it again.
      exit 1
    fi
    ${qemu}/bin/qemu-img create -b $NIX_DISK_IMAGE -F qcow2 -f qcow2 root.qcow2
    NIX_DISK_IMAGE=root.qcow2

    exec ${qemu-common.qemuBinary qemu} \
        -name ${config.system.name} \
        -m ${toString config.virtualisation.memorySize} \
        -smp ${toString config.virtualisation.cores} \
        -device virtio-rng-pci \
        ${concatStringsSep " " config.virtualisation.qemu.networkingOptions} \
        ${
          concatStringsSep " \\\n    " (
            mapAttrsToList (
              tag: share:
              "-virtfs local,path=${share.source},security_model=${share.securityModel},mount_tag=${tag}"
            ) config.virtualisation.sharedDirectories
          )
        } \
        ${drivesCmdLine config.virtualisation.qemu.drives} \
        ${concatStringsSep " \\\n    " config.virtualisation.qemu.options} \
        -drive id=MacHDD,if=virtio,file="root.qcow2",format=qcow2
        ''${QEMU_OPTS:-} \
        "$@"
  '';

in
{
  options = {
    # FIXME (copied from qemu-vm.nix)
    virtualisation.host.pkgs = mkOption {
      type = options.nixpkgs.pkgs.type;
      # default = pkgs;
      defaultText = literalExpression "pkgs";
      example = literalExpression ''
        import pkgs.path { system = "x86_64-darwin"; }
      '';
      description = ''
        Package set to use for the host-specific packages of the VM runner.
        Changing this to e.g. a Darwin package set allows running NixOS VMs on Darwin.
      '';
    };
    # FIXME (copied from qemu-vm.nix, increased 1G -> 4G)
    virtualisation.memorySize = mkOption {
      type = types.ints.positive;
      default = 6144; # 6 GiB
      description = ''
        The memory size of the virtual machine in MiB (1024×1024 bytes).
      '';
    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.cores = mkOption {
      type = types.ints.positive;
      default = 1;
      description = ''
        Specify the number of cores the guest is permitted to use.
        The number can be higher than the available cores on the
        host system.
      '';
    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.diskImage = mkOption {
      type = types.nullOr types.str;
      default = "./${config.system.name}.qcow2";
      defaultText = literalExpression ''"./''${config.system.name}.qcow2"'';
      description = ''
        Path to the disk image containing the root filesystem.
        The image will be created on startup if it does not
        exist.

        If null, a tmpfs will be used as the root filesystem and
        the VM's state will not be persistent.
      '';
    };
    # FIXME (copied from qemu-vm.nix)
    networking.primaryIPAddress = mkOption {
      type = types.str;
      default = "";
      internal = true;
      description = "Primary IP address used in /etc/hosts.";
    };
    # FIXME (copied from qemu-vm.nix)
    networking.primaryIPv6Address = mkOption {
      type = types.str;
      default = "";
      internal = true;
      description = "Primary IPv6 address used in /etc/hosts.";
    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.vlans = mkOption {
      type = types.listOf types.ints.unsigned;
      default = if config.virtualisation.interfaces == { } then [ 1 ] else [ ];
    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.qemu = {
      networkingOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "-net nic,netdev=user.0,model=virtio"
          "-netdev user,id=user.0,\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
        ];
        description = ''
          Networking-related command-line options that should be passed to qemu.
          The default is to use userspace networking (SLiRP).
          See the [QEMU Wiki on Networking](https://wiki.qemu.org/Documentation/Networking) for details.

          If you override this option, be advised to keep
          `''${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}` (as seen in the example)
          to keep the default runtime behaviour.
        '';
      };
      options = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-vga std" ];
        description = ''
          Options passed to QEMU.
          See [QEMU User Documentation](https://www.qemu.org/docs/master/system/qemu-manpage) for a complete list.
        '';
      };
      drives = mkOption {
        type = types.listOf (types.submodule driveOpts);
        description = "Drives passed to qemu.";
      };

    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.sharedDirectories = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.source = mkOption {
            type = types.str;
            description = "The path of the directory to share, can be a shell variable";
          };
          options.target = mkOption {
            type = types.path;
            description = "The mount point of the directory inside the virtual machine";
          };
          options.securityModel = mkOption {
            type = types.enum [
              "passthrough"
              "mapped-xattr"
              "mapped-file"
              "none"
            ];
            default = "mapped-xattr";
            description = ''
              The security model to use for this share:

              - `passthrough`: files are stored using the same credentials as they are created on the guest (this requires QEMU to run as root)
              - `mapped-xattr`: some of the file attributes like uid, gid, mode bits and link target are stored as file attributes
              - `mapped-file`: the attributes are stored in the hidden .virtfs_metadata directory. Directories exported by this security model cannot interact with other unix tools
              - `none`: same as "passthrough" except the sever won't report failures if it fails to set file attributes like ownership
            '';
          };
        }
      );
      default = { };
      example = {
        my-share = {
          source = "/path/to/be/shared";
          target = "/mnt/shared";
        };
      };
      description = ''
        An attributes set of directories that will be shared with the
        virtual machine using VirtFS (9P filesystem over VirtIO).
        The attribute name will be used as the 9P mount tag.
      '';
    };
    # FIXME (copied from qemu-vm.nix)
    virtualisation.interfaces = mkOption {
      default = { };
      example = {
        enp1s0.vlan = 1;
      };
      description = ''
        Network interfaces to add to the VM.
      '';
      type =
        with types;
        attrsOf (submodule {
          options = {
            vlan = mkOption {
              type = types.ints.unsigned;
              description = ''
                VLAN to which the network interface is connected.
              '';
            };

            assignIP = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Automatically assign an IP address to the network interface using the same scheme as
                virtualisation.vlans.
              '';
            };
          };
        });
    };
    system.name = mkOption {
      type = types.str;
      # FIXME: not accurate?
      default = name;
    };
  };
  config = {
    # FIXME
    system.build.vm =
      hostPkgs.runCommand "nixos-vm"
        {
          preferLocalBuild = true;
          meta.mainProgram = "run-${config.system.name}-vm";
        }
        ''
          mkdir -p $out/bin
          ln -s ${config.system.build.toplevel} $out/system
          ln -s ${hostPkgs.writeScript "run-nixos-vm" startVM} $out/bin/run-${config.system.name}-vm
        '';
    virtualisation.qemu.options = [
      "-enable-kvm" # ??
      "-machine"
      "q35,accel=kvm"
      "-usb" "-device" "usb-kbd" "-device" "usb-tablet" "-device" "usb-tablet"
      "-cpu" "Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"
      "-device" "usb-ehci,id=ehci"
      "-device" "nec-usb-xhci,id=xhci"
      "-global" "nec-usb-xhci.msi=off"
      "-device" ''isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"''
      "-smbios" "type=2"
      "-device" "ich9-intel-hda" "-device" "hda-duplex"
      "-device" "virtio-vga"

    ];
    virtualisation.qemu.drives = mkMerge [
      []
      # (mkIf (cfg.diskImage != null) [
      #   {
      #     name = "MacHDD";
      #     file = ''"$NIX_DISK_IMAGE"'';
      #     driveExtraOpts.cache = "writeback";
      #     driveExtraOpts.werror = "report";
      #     deviceExtraOpts.bootindex = "1";
      #     deviceExtraOpts.serial = rootDriveSerialAttr;
      #   }
      # ])
    ];

  };
}