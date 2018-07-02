{ config, lib, pkgs, ... }:

with lib;

# TODO: check this actually fits RFC
# TODO: service start => generates image if need be => boot on kernel+initrd
# from host fs => guest waits in initrd with a predefined ssh key => host sends
# closure and tells the guest to boot with the right configuration => guest
# boots => guest spawns sshd with the same predefined ssh key
# TODO: forward resolv.conf via 9pfs, cp -L it at start and reload of service
# TODO: see what happens when a VM addition changes the IP addresses of other VMs

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

            Will be auto-filled with a valid IP in the range if left undefined.
            Warning: don't fill some ip4's and not others, collision checking
            isn't supported!
          '';
      };
      ip6 = mkOption {
        type = types.str;
        description =
          ''
            IPv6 address of the guest (must be in the subnet defined by
            <replaceable>vms.ip6</replaceable>).

            Will be auto-filled with a valid IP in the range if left undefined.
            Warning: don't fill some ip6's and not others, collision checking
            isn't supported!
          '';
      };
      mac = mkOption {
        type = types.str;
        description =
          ''
            MAC address of the guest.

            Will be auto-filled with a random MACif left undefined.
            Warning: don't fill some mac's and not others, collision checking
            isn't supported!
          '';
      };

      shared = mkOption {
        type = with types; attrsOf str;
        default = {};
        example = { "/guest/directory" = "/maps/to/host/directory"; };
        description =
        ''
          Associations guest => host of files to make available to the guest.
          The content of these paths won't enter the store, so may be secrets.
          They will be read by user
          <literal>vm-<replaceable>vmname</replaceable></literal>:<literal>vm-<replaceable>vmname</replaceable></literal>.
        '';
      };
      diskSize = mkOption {
        type = types.int;
        default = 10240;
        description =
          ''
            Maximum size of the VM disk (in MiB), excluding shared paths.
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

      channels = mkOption {
        type = with types; attrsOf str;
        default = {};
        example = {
          nixos = "https://nixos.org/channels/nixos-unstable";
        };
        description =
          ''
            Channel to make available to the VM. Note that its base
            configuration will not be built with this channel, but with the
            channel of the enclosing configuration.nix. It will only be used for
            things such as <command>nix-shell -p iotop</command>.
          '';
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
      ip4 = mkDefault (genIPv4 (addToIPv4 (parseIPv4 cfg.ip4.address) id));
      ip6 = mkDefault (genIPv6 (addToIPv6 (parseIPv6 cfg.ip6.address) id));
      mac = mkDefault (genMAC  (addToMAC  (parseMAC "56:00:00:00:00:00") id));
    };
  };

  extraHosts =
    optionalString cfg.addHostNames (
      ''
        ${cfg.ip4.address} host.localhost
        ${cfg.ip6.address} host.localhost
      '' +
      concatMapStrings (name:
        ''
          # machine MAC: ${cfg.machines.${name}.mac} vm-${name}.localhost
          ${cfg.machines.${name}.ip4} vm-${name}.localhost
          ${cfg.machines.${name}.ip6} vm-${name}.localhost
        ''
      ) (attrNames cfg.machines)
    );

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
    boot.postBootCommands =
      concatMapStrings (chan:
        ''
          echo "adding channel ${chan}"
          ${config.nix.package.out}/bin/nix-channel --add \
            ${cfg.machines.${name}.channels.${chan}} ${chan}
        ''
      ) (attrNames cfg.machines.${name}.channels);

    fileSystems = {
      "/".device = "/dev/vda";
      "/nix/store" = {
        device = "store";
        fsType = "9p";
        # TODO: optimize the size given in msize by highly evolved trial-and-failure (and just below, too)
        options = [ "trans=virtio" "version=9p2000.L" "msize=262144" ];
        neededForBoot = true;
      };
    } // listToAttrs (imap (i: n: nameValuePair n {
      device = "shared${toString i}";
      fsType = "9p";
      options = [ "trans=virtio" "version=9p2000.L" "msize=262144" ];
    }) (attrNames cfg.machines.${name}.shared));

    networking = let mcfg = cfg.machines.${name}; in {
      hostName = mkDefault name;
      extraHosts = extraHosts;
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
        ''-nographic -serial unix:"${cfg.rpath}/${name}/socket.unix",server,nowait''
        # File systems
        ''-drive file="${cfg.path}/${name}/image.qcow2",if=virtio,media=disk''
        ''-virtfs local,path="${cfg.path}/${name}/store",security_model=none,mount_tag=store''
        # Network
        ''-netdev type=tap,id=net0,ifname=vm-${name},script=no,dscript=no''
        ''-device virtio-net-pci,netdev=net0,mac=${mcfg.mac}''
        # Boot
        ''-kernel ${toplevel}/kernel''
        ''-initrd ${toplevel}/initrd''
        ''-append "$(cat ${toplevel}/kernel-params) init=${toplevel}/init console=ttyS0 boot.shell_on_fail"''
        # TODO: remove boot.shell_on_fail
      ] ++ # Shared filesystems
      imap (i: n:
        ''-virtfs proxy,socket="${cfg.rpath}/${name}/virtfs${toString i}",mount_tag="shared${toString i}"''
      ) (attrNames mcfg.shared)
    );

  referencesGraph = name: let mcfg = cfg.machines.${name}; in
    pkgs.stdenv.mkDerivation {
      name = "references-vm-${name}";
      passAsFile = [ "buildCommand" ];
      buildCommand = "grep '/nix/store' closure | sed 's_/nix/store/__' | sort -u > $out";
      exportReferencesGraph = [ "closure" mcfg.config.system.build.toplevel ];
    };

  setupVM = name: let mcfg = cfg.machines.${name}; in
    ''
      mkdir -p "${cfg.path}/${name}" "${cfg.rpath}/${name}"
      chown "vm-${name}:vm-${name}" "${cfg.path}/${name}" "${cfg.rpath}/${name}"
      chmod 700 "${cfg.path}/${name}" "${cfg.rpath}/${name}"

      image="${cfg.path}/${name}/image.qcow2"
      store="${cfg.path}/${name}/store"
      targetStore="${referencesGraph name}"

      # Generate image if need be
      if [ \! -e "$image" ]; then
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$image" \
          ${toString mcfg.diskSize}M || exit 1
        chown "vm-${name}:vm-${name}" "$image"
      fi

      # Regenerate store
      mkdir -p "${cfg.path}/${name}/store"
      ls "$store" | while read path; do
        if ! grep "$path" "$targetStore" > /dev/null; then
          rm -Rf "$path"
        fi
      done
      cat "$targetStore" | while read path; do
        ${pkgs.rsync}/bin/rsync -a --ignore-existing "/nix/store/$path" "$store"
      done
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

    path = mkOption {
      type = types.str;
      default = "/var/lib/vm";
      description =
        ''
          Path inside which to put all VM-related data. All files will be kept
          in <literal>''${vms.path}/''${name}</literal>.

          The main disk image will be in <literal>image.qcow2</literal>, and a
          serial console can be accessed by running <command>screen</command> on
          the file <literal>screen</literal>.
        '';
    };
    rpath = mkOption {
      type = types.str;
      default = "/run/vm";
      description = "Path for temporary VM data.";
    };

    addHostNames = mkOption {
      type = types.bool;
      default = true;
      description =
        ''
          Whether to add
          <command>vm-<replaceable>''${name}</replaceable>.localhost</command>
          (and <command>host.localhost</command>) hostnames on the host and
          guests to allow for easier inter-reachability.
        '';
    };

    machines = mkOption {
      type = types.attrsOf (types.submodule machineOpts);
      default = {};
      example = literalExample
        ''
          { nginx =
            { memorySize = 128;
              vcpus = 2;
              config =
              { services.nginx.enable = true;
                networking.firewall.allowedTCPPorts = [ 80 ];
              };
            };
          };
          # Somewhere under, port forwarding to ''${vms.machines.nginx.ip4} and
          # ''${vms.machines.nginx.ip6}.
        '';
      description =
        ''
          A set of NixOS system configurations to be run as virtual machines.
          Each VM appears as a service
          <literal>vm-<replaceable>name</replaceable></literal> on the host
          system, allowing it to be started and stopped via
          <command>systemctl</command>.

          Access to the serial console of the VM can be found using
          <command>screen
          <replaceable>vms.path</replaceable>/<replaceable>vmname</replaceable>/screen</command>.

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
      proxyUnits = name:
        listToAttrs (imap (i: n: nameValuePair "vm-${name}-shared-${toString i}" {
          description = "Virtfs proxy helper for VM ${name} path ${n}";
          script =
            ''
              exec ${pkgs.qemu}/bin/virtfs-proxy-helper \
                -p "${cfg.machines.${name}.shared.${n}}" \
                -s "${cfg.rpath}/${name}/virtfs${toString i}" \
                -u "vm-${name}" -g "vm-${name}" \
                --nodaemon
            '';
        }) (attrNames cfg.machines.${name}.shared));
      proxyUnitsServices = name:
        map (x: "${x}.service") (attrNames (proxyUnits name));
      unit = name: {
        description = "VM '${name}'";
        preStart = setupVM name;
        script = "exec ${qemuCommand name}";
        requires = [ "vm-${name}-netdev.service" ] ++ (proxyUnitsServices name);
        after = [ "vm-${name}-netdev.service" ] ++ (proxyUnitsServices name);
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "vm-${name}";
          Group = "vm-${name}";
          PermissionsStartOnly = "true";
          TimeoutStartSec = "infinity";
        };
      };
      consoleUnit = name: {
        description = "Console for VM '${name}'";
        script = # TODO: get why this has to be restarted when pre-start takes too long
          ''
            # Wait for socket creation
            sleep 1
            exec ${pkgs.socat}/bin/socat \
                PTY,link="${cfg.path}/${name}/screen" \
                "${cfg.rpath}/${name}/socket.unix"
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
      mapAttrs' (name: _: nameValuePair "vm-${name}-console" (consoleUnit name)) cfg.machines //
      foldAttrs (n: _: n) "" (map proxyUnits (attrNames cfg.machines));

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

    networking.extraHosts = extraHosts;

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
