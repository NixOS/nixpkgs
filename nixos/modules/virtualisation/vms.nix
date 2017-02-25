{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vms;

  system = config.nixpkgs.system;

  machineOpts = { name, config, ... }: {
    options = {
      # TODO: allow leaving these field unset and auto-fill it with a valid value
      ip4 = mkOption {
        type = types.str;
        description =
        ''
          IPv4 address of the guest (must be in the subnet defined by
          <replaceable>vms.ip4</replaceable>.
        '';
      };
      ip6 = mkOption {
        type = types.str;
        description =
        ''
          IPv6 address of the guest (must be in the subnet defined by
          <replaceable>vms.ip6</replaceable>.
        '';
      };

      persistent = mkOption {
        type = with types; listOf str;
        description =
          ''
            List of paths to make persistent across reboots of the VM. Please
            note all other paths may or may not be erased between VM reboots.
            These paths will be stored on the host filesystem, and won't be
            erased when the VM is removed for the configuration, in order to
            avoid accidental data loss.
          '';
      };
      shared = mkOption {
        type = with types; attrsOf str;
        description =
        ''
          Associations guest => host of files to make available to the guest.
          These paths won't enter the store, so may be secrets. They will be
          read by user
          <literal>vm-<replaceable>vmname</replaceable></literal>:<literal>vm-<replaceable>vmname</replaceable></literal>.
        ''; # TODO: Switch from running as root to running as vm-[vmname]
      };
      diskSize = mkOption {
        type = types.int;
        default = 10240;
        description =
          ''
            Maximum size of the VM disk (in MiB), excluding persistent and
            shared paths.
          '';
      };
      memorySize = mkOption {
        type = types.int;
        default = 1024;
        description = "Amount of RAM (in MiB) allocated to this VM.";
      };

      config = mkOption {
        description =
        ''
          A specification of the desired configuration of this VM, as a NixOS
          module.
        '';
        type = mkOptionType {
          name = "Toplevel NixOS config";
          merge = loc: defs: (import ../../lib/eval-config.nix {
            inherit system;
            modules =
              [ (extraConfig name) ] ++ (map (x: x.value) defs);
            prefix = [ "vms" "machines" name ];
          }).config;
        };
      };
    };
  };

  extraConfig = name: {
    boot.loader.grub.enable = false;

    networking = {
      hostName = mkDefault name;
      useDHCP = false;
      defaultGateway = mkDefault cfg.ip4.address;
      defaultGateway6 = mkDefault cfg.ip6.address;
      /* TODO
      interfaces.eth0 = {
        ip4.address = cfg.${name}.ip4;
        ip4.prefixLength = cfg.ip4.prefixLength;
        ip6.address = cfg.${name}.ip6;
        ip6.prefixLength = cfg.ip6.prefixLength;
      };
      */
    };
  };

  startVM = name:
    let mcfg = cfg.machines.${name}; in
    ''
      #!${pkgs.stdenv.shell}

      image = "${cfg.imagesPath}/${name}.img"
      store = "${cfg.storesPath}/${name}"
      persist = "${cfg.persistPath}/${name}"
      if [ \! -e "$image" ]; then
        mkdir -p "$store" "$persist"
        mkdir ${concatStringsSep " " (map (x: "$persist/" + x) mcfg.persistent)}

        mkdir -p "${cfg.imagesPath}"
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$image" \
          ${toString mcfg.diskSize}M || exit 1
      fi

      # TODO: handle shared and persisted
      # TODO: Have a look at regInfo (@qemu-vm.nix) and understand what it's doing
      exec ${pkgs.qemu}/bin/qemu-kvm \
        -name ${name} \
        -m ${toString mcfg.memorySize} \
        ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"} \
        -virtfs local,path="$store",security_model=none,mount_tag=store \
        -drive file="$image",if=virtio \
        -kernel ${mcfg.config.system.build.toplevel}/kernel \
        -initrd ${mcfg.config.system.build.toplevel}/initrd \
        -append "$(cat ${mcfg.config.system.build.toplevel}/kernel-params) init=${mcfg.config.system.build.toplevel}/init console=ttyS0 \
        $@
    '';

in

{
  options.vms = {
    bridge = mkOption {
      type = types.str;
      description = "Name of the bridge to use for the VMs.";
      default = "br-vm";
    };
    ip4.address = mkOption {
      type = types.str;
      description = "IPv4 for the host on the VM bridge";
      default = "172.16.0.1";
    };
    ip4.prefixLength = mkOption {
      type = types.int;
      description = "IPv4 prefix length for the VM bridge";
      default = 12;
    };
    ip6.address = mkOption {
      type = types.str;
      description = "IPv6 for the host on the VM bridge.";
      default = "fd1d:fbcd:2a87:1::";
    };
    ip6.prefixLength = mkOption {
      type = types.str;
      description = "IPv6 prefix length for the VM bridge";
      default = 48;
    };

    persistPath = mkOption {
      type = types.str;
      default = "/var/lib/vm/persist";
      description =
        ''
          Path inside which to put the persisted directories of VMs.
        '';
    };
    imagesPath = mkOption {
      type = types.str;
      default = "/var/lib/vm/images";
      description = "Path inside which to put the VM images.";
    };
    storesPath = mkOption {
      type = types.str;
      default = "/var/lib/vm/stores";
      description = "Path to the stores";
    };

    machines = mkOption {
      type = types.attrsOf (types.submodule machineOpts);
      default = {};
      # TODO: example = ?
      description =
        ''
          A set of NixOS system configurations to be run as virtual machines.
          Each VM appears as a service
          <literal>vm-<replaceable>name</replaceable></literal> on the host
          system, allowing it to be started and stopped via
          <command>systemctl</command>.

          Please note VMs are heavily identified by their name, so the key
          should not be changed light-heartedly.
        '';
    };
  };

  config =
    let unit = name: {
      description = "VM '${name}'";
      script = startVM name;
    }; in
  mkIf (cfg.machines != {}) {
    systemd.services = mapAttrs' (name: _: nameValuePair "vm-${name}" (unit name)) cfg.machines;
  };
}
