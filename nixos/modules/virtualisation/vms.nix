{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vms;

  system = config.nixpkgs.system;

  machineOpts = { name, config, ... }: {
    options = {
      ip4 = mkOption {
        type = types.str;
        description =
          ''
            IPv4 address of the guest (must be in the subnet defined by
            <replaceable>vms.ip4</replaceable>).
          '';
      };
      ip6 = mkOption {
        type = types.str;
        description =
          ''
            IPv6 address of the guest (must be in the subnet defined by
            <replaceable>vms.ip6</replaceable>).
          '';
      };
      mac = mkOption {
        type = types.str;
        description = "MAC address of the guest.";
      };

      persistent = mkOption {
        type = with types; listOf str;
        default = [];
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
        '';
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
      vcpus = mkOption {
        type = types.int;
        default = 1;
        description = "Number of cores available to this VM.";
      };

      store = mkOption {
        type = types.path;
        internal = true;
        visible = false;
        description = "Path to the store of the VM.";
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

    config =
    let
      id = 1 + lib.findFirstIndex (x: x == name) (attrNames cfg.machines);
    in
    {
      shared = genAttrs config.persistent (n: "${cfg.persistPath}/${name}${n}");
      ip4 = mkDefault (genIPv4 (addToIPv4 (parseIPv4 cfg.ip4.address) id));
      ip6 = mkDefault (genIPv6 (addToIPv6 (parseIPv6 cfg.ip6.address) id));
      mac = mkDefault (genMAC  (addToMAC  (parseMAC "56:00:00:00:00:00") id));

      store = pkgs.stdenv.mkDerivation {
        name = "vm-${name}-store";
        phases = [ "buildPhase" ];
        buildInputs = [ config.config.system.build.toplevel ];
        exportReferencesGraph = [ "closure" config.config.system.build.toplevel ];
        preferLocalBuild = true;
        buildPhase =
          ''
            # TODO: find way to directly do the hardlinking instead of relying on nix
            function recurse_in_dir_unused() {
              if [ -d "/nix/store/$1" ]; then
                mkdir "$out/$1"
                ls "/nix/store/$1" | while read elem; do
                  recurse_in_dir "$1/$elem"
                done
              else
                ln "/nix/store/$1" "$out/$1"
              fi
            }

            function recurse_in_dir() {
              ${pkgs.rsync}/bin/rsync -a "/nix/store/$1" "$out"
            }

            mkdir $out
            cat closure | grep '/nix/store/' | sed 's_/nix/store/__' | sort -u | while read elem; do
              recurse_in_dir "$elem"
            done
          '';
      };
    };
  };

  extraConfig = name: {
    boot.loader.grub.enable = false;

    boot.initrd.kernelModules = [
      "virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk"
      "virtio_console" "9p" "9pnet" "9pnet_virtio"
    ];
    boot.initrd.extraUtilsCommands =
      ''
        # Need mke2fs in the initrd
        copy_bin_and_libs ${pkgs.e2fsprogs}/bin/mke2fs
      '';
    boot.initrd.postDeviceCommands =
      ''
        # Format the boot disk if need be
        FSTYPE=$(blkid -o value -s TYPE /dev/vda || true)
        if [ -z "$FSTYPE" ]; then
          mke2fs -t ext4 /dev/vda
        fi
      '';
    boot.initrd.postMountCommands =
      ''
        # Mark as being NixOS
        mkdir -p $targetRoot/etc
        touch $targetRoot/etc/NIXOS

        mkdir -p $targetRoot/boot
      '';

    fileSystems = {
      "/".device = "/dev/vda";
      "/nix/store" = {
        device = "store";
        fsType = "9p";
        # TODO: optimize the size given in msize by highly evolved trial-and-failure (and just below, too)
        # Warning: cache=loose works only because this mount is read-only.
        options = [ "trans=virtio" "version=9p2000.L" "cache=loose" "msize=262144" ];
      };
    } // listToAttrs (imap (i: n: nameValuePair n {
      device = "shared${toString i}";
      fsType = "9p";
      options = [ "trans=virtio" "version=9p2000.L" "msize=262144" ];
    }) (attrNames cfg.machines.${name}.shared));

    networking = let mcfg = cfg.machines.${name}; in {
      hostName = mkDefault name;
      useDHCP = false;
      defaultGateway = mkDefault cfg.ip4.address;
      defaultGateway6 = mkDefault cfg.ip6.address;
      interfaces.enp0s4 = {
        ip4 = [ { address = mcfg.ip4; prefixLength = cfg.ip4.prefixLength; } ];
        ip6 = [ { address = mcfg.ip6; prefixLength = cfg.ip6.prefixLength; } ];
      };
    };
  };

  qemuCommand = name:
    let
      mcfg = cfg.machines.${name};
      toplevel = mcfg.config.system.build.toplevel;
    in
    # TODO: repair the nix db (like with regInfo @qemu-vm.nix?)
    concatStringsSep " " (
      [ # Generic configuration
        ''${pkgs.qemu}/bin/qemu-kvm''
        ''-name ${name}''
        ''-m ${toString mcfg.memorySize}''
        ''-smp ${toString mcfg.vcpus}''
        ''${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"}''
        # Run headless
        ''-nographic -serial unix:"${cfg.consolePath}/${name}/socket.unix",server,nowait''
        # File systems
        ''-drive file="${cfg.imagesPath}/${name}.img",if=virtio,media=disk''
        ''-virtfs local,path="${mcfg.store}",security_model=none,mount_tag=store''
        # Network
        ''-netdev type=tap,id=net0,ifname=vm-${name},script=no,dscript=no''
        ''-device virtio-net-pci,netdev=net0,mac=${mcfg.mac}''
        # Boot
        ''-kernel ${toplevel}/kernel''
        ''-initrd ${toplevel}/initrd''
        ''-append "$(cat ${toplevel}/kernel-params) init=${toplevel}/init console=ttyS0"''
      ] ++ # Shared and persisted filesystems
      imap (i: n:
        ''-virtfs local,path="${mcfg.shared.${n}}",security_model=mapped-xattr,mount_tag="shared${toString i}"''
      ) (attrNames mcfg.shared)
    );

  setupVM = name: let mcfg = cfg.machines.${name}; in
    ''
      image="${cfg.imagesPath}/${name}.img"
      console="${cfg.consolePath}/${name}/socket.unix"
      persist="${cfg.persistPath}/${name}"

      # Generate paths
      mkdir -p \
        "$persist" "${cfg.imagesPath}" "${cfg.consolePath}/${name}" \
        ${concatStringsSep " " (map (x: "\"$persist" + x + "\"") mcfg.persistent)}

      if [ \! -e "$image" ]; then
        # TODO: auto-cleanup the image when the VM is removed from configuration
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$image" \
          ${toString mcfg.diskSize}M || exit 1
      fi

      # Ensure permissions
      chown "vm-${name}:vm-${name}" "${cfg.consolePath}/${name}" "$persist" "$image"
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
      type = types.int;
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
    consolePath = mkOption {
      type = types.str;
      default = "/var/lib/vm/consoles";
      description =
        ''
          Path to the serial consoles of the VMs. Use <command>screen
          <replaceable>/var/lib/vm/consoles/vmname</replaceable>/screen</command>
          to connect.
        '';
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

          Access to the serial console of the VM can be found using
          <command>screen
          <replaceable>vms.consolePath</replaceable>/<replaceable>vmname</replaceable></command>.

          Please note VMs are heavily identified by their name, so the key
          should not be changed light-heartedly.

          Warning: this will conflict with any ebtables configuration you may
          have from elsewhere, with undefined results. This will be possible to
          fix when a nixos module handling ebtables will be made.
        ''; # TODO: fix this warning. ebtables is rarely enough used so that I think it's not a *huge* issue, but it should be dealt with nonetheless
    };
  };

  config =
    let
      unit = name: {
        description = "VM '${name}'";
        preStart = setupVM name;
        script = "exec ${qemuCommand name}";
        requires = [ "vm-${name}-netdev.service" ];
        after = [ "vm-${name}-netdev.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "vm-${name}";
          Group = "vm-${name}";
          PermissionsStartOnly = "true";
        };
      };
      consoleUnit = name: {
        description = "Console for VM '${name}'";
        script =
          ''
            # Wait for socket creation
            sleep 1
            exec ${pkgs.socat}/bin/socat \
                PTY,link="${cfg.consolePath}/${name}/screen" \
                "${cfg.consolePath}/${name}/socket.unix"
          '';
        partOf = [ "vm-${name}.service" ];
        after = [ "vm-${name}.service" ];
        wantedBy = [ "vm-${name}.service" ];
        serviceConfig = {
          User = "vm-${name}";
          Group = "vm-${name}";
        };
      };
    in
  mkIf (cfg.machines != {}) {
    systemd.services =
      mapAttrs' (name: _: nameValuePair "vm-${name}" (unit name)) cfg.machines //
      mapAttrs' (name: _: nameValuePair "vm-${name}-console" (consoleUnit name)) cfg.machines;

    users.groups = mapAttrs' (name: _: nameValuePair "vm-${name}" {}) cfg.machines;
    users.users =
      mapAttrs' (name: _: nameValuePair
        "vm-${name}"
        { description = "VM ${name}";
          isSystemUser = true;
          group = "vm-${name}";
        }) cfg.machines;

    networking.bridges.${cfg.bridge} = {
      interfaces = mapAttrsToList (name: _: "vm-${name}") cfg.machines;
    };

    networking.interfaces =
      mapAttrs' (name: _: nameValuePair
        "vm-${name}"
        { useDHCP = false;
          virtual = true;
          virtualType = "tap";
          virtualOwner = "vm-${name}";
        }) cfg.machines //
      { ${cfg.bridge} = {
          ip4 = [ cfg.ip4 ];
          ip6 = [ cfg.ip6 ];
        };
      };

    # TODO: put this behind an option
    networking.extraHosts =
      concatMapStrings (name:
        ''
          # machine MAC: ${cfg.machines.${name}.mac} vm-${name}.localhost
          ${cfg.machines.${name}.ip4} vm-${name}.localhost
          ${cfg.machines.${name}.ip6} vm-${name}.localhost
        ''
      ) (attrNames cfg.machines);

    networking.firewall.extraCommands =
    let ebtables = "${pkgs.ebtables}/bin/ebtables"; in
      ''
        # Define chains and policies
        ${ebtables} -P FORWARD DROP
        ${ebtables} -P INPUT DROP
        ${ebtables} -P OUTPUT DROP
        ${ebtables} -F FORWARD
        ${ebtables} -F INPUT
        ${ebtables} -F OUTPUT
        ${ebtables} -N CHECK_SRC_4
        ${ebtables} -N CHECK_SRC_6
        ${ebtables} -N CHECK_DST_4
        ${ebtables} -N CHECK_DST_6
        ${ebtables} -N FAIL
        ${ebtables} -P CHECK_SRC_4 DROP
        ${ebtables} -P CHECK_SRC_6 DROP
        ${ebtables} -P CHECK_DST_4 DROP
        ${ebtables} -P CHECK_DST_6 DROP
        ${ebtables} -P FAIL DROP

        # TODO: be more strict on ARP's, to ban a VM from DOSing another VM by
        # taking its IP?
        ${ebtables} -A FORWARD -p ARP -j ACCEPT
        ${ebtables} -A INPUT -p ARP -j ACCEPT
        ${ebtables} -A OUTPUT -p ARP -j ACCEPT
        # Allow Neighbour Discovery Protocol (same as ARP, same TODO)
        ${ebtables} -A FORWARD -p IPv6 --ip6-protocol ipv6-icmp --ip6-icmp-type 135:136/0 -j ACCEPT
        ${ebtables} -A INPUT -p IPv6 --ip6-protocol ipv6-icmp --ip6-icmp-type 135:136/0 -j ACCEPT
        ${ebtables} -A OUTPUT -p IPv6 --ip6-protocol ipv6-icmp --ip6-icmp-type 135:136/0 -j ACCEPT

        # TODO: check destination for INPUT / source for OUTPUT? (a malicious
        # host is most likely out of any relevant threat model, so...)
        ${ebtables} -A FORWARD -p IPv4 -j CHECK_SRC_4
        ${ebtables} -A FORWARD -p IPv4 -j CHECK_DST_4
        ${ebtables} -A FORWARD -p IPv4 -j ACCEPT
        ${ebtables} -A INPUT -p IPv4 -j CHECK_SRC_4
        ${ebtables} -A INPUT -p IPv4 -j ACCEPT
        ${ebtables} -A OUTPUT -p IPv4 -j CHECK_DST_4
        ${ebtables} -A OUTPUT -p IPv4 -j ACCEPT

        ${ebtables} -A FORWARD -p IPv6 -j CHECK_SRC_6
        ${ebtables} -A FORWARD -p IPv6 -j CHECK_DST_6
        ${ebtables} -A FORWARD -p IPv6 -j ACCEPT
        ${ebtables} -A INPUT -p IPv6 -j CHECK_SRC_6
        ${ebtables} -A INPUT -p IPv6 -j ACCEPT
        ${ebtables} -A OUTPUT -p IPv6 -j CHECK_DST_6
        ${ebtables} -A OUTPUT -p IPv6 -j ACCEPT

        ${ebtables} -A FORWARD -j FAIL
        ${ebtables} -A INPUT -j FAIL
        ${ebtables} -A OUTPUT -j FAIL

        # CHECK_(SRC|DST)_[46]
      '' + concatMapStrings (name:
        let mcfg = cfg.machines.${name}; in
        ''
          ${ebtables} -A CHECK_SRC_4 -p IPv4 -i vm-${name} -s ${mcfg.mac} --ip-src ${mcfg.ip4} -j RETURN
          ${ebtables} -A CHECK_SRC_6 -p IPv6 -i vm-${name} -s ${mcfg.mac} --ip6-src ${mcfg.ip6} -j RETURN

          ${ebtables} -A CHECK_DST_4 -p IPv4 -o vm-${name} -d ${mcfg.mac} --ip-dst ${mcfg.ip4} -j RETURN
          ${ebtables} -A CHECK_DST_6 -p IPv6 -o vm-${name} -d ${mcfg.mac} --ip6-dst ${mcfg.ip6} -j RETURN
        ''
      ) (attrNames cfg.machines) +
      ''
        ${ebtables} -A CHECK_SRC_4 -j FAIL
        ${ebtables} -A CHECK_SRC_6 -j FAIL
        ${ebtables} -A CHECK_DST_4 -j FAIL
        ${ebtables} -A CHECK_DST_6 -j FAIL

        ${ebtables} -A FAIL --log --log-prefix "Dropping frame" --log-ip --log-ip6 --log-arp -j DROP
      '';
  };
}
