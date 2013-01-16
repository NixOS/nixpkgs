{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;
  hasVirtuals = any (i: i.virtual) interfaces;

  interfaceOpts = { name, ... }: {

    options = {

      name = mkOption {
        example = "eth0";
        type = types.string;
        description = "Name of the interface.";
      };

      ipAddress = mkOption {
        default = null;
        example = "10.0.0.1";
        type = types.nullOr types.string;
        description = ''
          IP address of the interface.  Leave empty to configure the
          interface using DHCP.
        '';
      };

      prefixLength = mkOption {
        default = null;
        example = 24;
        type = types.nullOr types.int;
        description = ''
          Subnet mask of the interface, specified as the number of
          bits in the prefix (<literal>24</literal>).
        '';
      };

      subnetMask = mkOption {
        default = "";
        example = "255.255.255.0";
        type = types.string;
        description = ''
          Subnet mask of the interface, specified as a bitmask.
          This is deprecated; use <option>prefixLength</option>
          instead.
        '';
      };

      macAddress = mkOption {
        default = null;
        example = "00:11:22:33:44:55";
        type = types.nullOr types.string;
        description = ''
          MAC address of the interface. Leave empty to use the default.
        '';
      };

      virtual = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether this interface is virtual and should be created by tunctl.
          This is mainly useful for creating bridges between a host a virtual
          network such as VPN or a virtual machine.

          Defaults to tap device, unless interface contains "tun" in its name.
        '';
      };

      virtualOwner = mkOption {
        default = "root";
        type = types.uniq types.string;
        description = ''
          In case of a virtual device, the user who owns it.
        '';
      };

      proxyARP = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Turn on proxy_arp for this device (and proxy_ndp for ipv6).
          This is mainly useful for creating pseudo-bridges between a real
          interface and a virtual network such as VPN or a virtual machine for
          interfaces that don't support real bridging (most wlan interfaces).
          As ARP proxying acts slightly above the link-layer, below-ip traffic
          isn't bridged, so things like DHCP won't work. The advantage above
          using NAT lies in the fact that no IP addresses are shared, so all
          hosts are reachable/routeable.

          WARNING: turns on ip-routing, so if you have multiple interfaces, you
          should think of the consequence and setup firewall rules to limit this.
        '';
      };

    };

    config = {
      name = mkDefault name;
    };

  };

in

{

  ###### interface

  options = {

    networking.hostName = mkOption {
      default = "nixos";
      description = ''
        The name of the machine.  Leave it empty if you want to obtain
        it from a DHCP server (if using DHCP).
      '';
    };

    networking.enableIPv6 = mkOption {
      default = true;
      description = ''
        Whether to enable support for IPv6.
      '';
    };

    networking.defaultGateway = mkOption {
      default = "";
      example = "131.211.84.1";
      description = ''
        The default gateway.  It can be left empty if it is auto-detected through DHCP.
      '';
    };

    networking.defaultGatewayWindowSize = mkOption {
      default = null;
      example = 524288;
      type = types.nullOr types.int;
      description = ''
        The window size of the default gateway. It limits maximal data bursts that TCP peers
        are allowed to send to us.
      '';
    };

    networking.nameservers = mkOption {
      default = [];
      example = ["130.161.158.4" "130.161.33.17"];
      description = ''
        The list of nameservers.  It can be left empty if it is auto-detected through DHCP.
      '';
    };

    networking.domain = mkOption {
      default = "";
      example = "home";
      description = ''
        The domain.  It can be left empty if it is auto-detected through DHCP.
      '';
    };

    networking.localCommands = mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = ''
        Shell commands to be executed at the end of the
        <literal>network-interfaces</literal> Upstart job.  Note that if
        you are using DHCP to obtain the network configuration,
        interfaces may not be fully configured yet.
      '';
    };

    networking.interfaces = mkOption {
      default = {};
      example =
        { eth0 = {
            ipAddress = "131.211.84.78";
            subnetMask = "255.255.255.128";
          };
        };
      description = ''
        The configuration for each network interface.  If
        <option>networking.useDHCP</option> is true, then every
        interface not listed here will be configured using DHCP.
      '';
      type = types.loaOf types.optionSet;
      options = [ interfaceOpts ];
    };

    networking.bridges = mkOption {
      default = { };
      example =
        { br0.interfaces = [ "eth0" "eth1" ];
          br1.interfaces = [ "eth2" "wlan0" ];
        };
      description =
        ''
          This option allows you to define Ethernet bridge devices
          that connect physical networks together.  The value of this
          option is an attribute set.  Each attribute specifies a
          bridge, with the attribute name specifying the name of the
          bridge's network interface.
        '';

      type = types.attrsOf types.optionSet;

      options = {

        interfaces = mkOption {
          example = [ "eth0" "eth1" ];
          type = types.listOf types.string;
          description =
            "The physical network interfaces connected by the bridge.";
        };

      };

    };

    networking.useDHCP = mkOption {
      default = true;
      merge = mergeEnableOption;
      description = ''
        Whether to use DHCP to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured.
      '';
    };
  };


  ###### implementation

  config = {

    boot.kernelModules = optional cfg.enableIPv6 "ipv6" ++ optional hasVirtuals "tun";

    environment.systemPackages =
      [ pkgs.host
        pkgs.iproute
        pkgs.iputils
        pkgs.nettools
        pkgs.wirelesstools
        pkgs.rfkill
        pkgs.openresolv
      ]
      ++ optional (cfg.bridges != {}) pkgs.bridge_utils
      ++ optional hasVirtuals pkgs.tunctl
      ++ optional cfg.enableIPv6 pkgs.ndisc6;

    security.setuidPrograms = [ "ping" "ping6" ];

    systemd.targets."network-interfaces" =
      { description = "All Network Interfaces";
        wantedBy = [ "network.target" ];
        unitConfig.X-StopOnReconfiguration = true;
      };

    systemd.services =
      let

        networkSetup =
          { description = "Networking Setup";

            after = [ "network-interfaces.target" ];
            before = [ "network.target" ];
            wantedBy = [ "network.target" ];

            path = [ pkgs.iproute ];

            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;

            script =
              ''
                # Set the static DNS configuration, if given.
                cat | ${pkgs.openresolv}/sbin/resolvconf -a static <<EOF
                ${optionalString (cfg.nameservers != [] && cfg.domain != "") ''
                  domain ${cfg.domain}
                ''}
                ${flip concatMapStrings cfg.nameservers (ns: ''
                  nameserver ${ns}
                '')}
                EOF

                # Disable or enable IPv6.
                if [ -e /proc/sys/net/ipv6/conf/all/disable_ipv6 ]; then
                  echo ${if cfg.enableIPv6 then "0" else "1"} > /proc/sys/net/ipv6/conf/all/disable_ipv6
                fi

                # Set the default gateway.
                ${optionalString (cfg.defaultGateway != "") ''
                  # FIXME: get rid of "|| true" (necessary to make it idempotent).
                  ip route add default via "${cfg.defaultGateway}" ${
                    optionalString (cfg.defaultGatewayWindowSize != null)
                      "window ${cfg.defaultGatewayWindowSize}"} || true
                ''}

                # Turn on forwarding if any interface has enabled proxy_arp.
                ${optionalString (any (i: i.proxyARP) interfaces) ''
                  echo 1 > /proc/sys/net/ipv4/ip_forward
                ''}

                # Run any user-specified commands.
                ${cfg.localCommands}
              '';
          };

        # For each interface <foo>, create a job ‘<foo>-cfg.service"
        # that performs static configuration.  It has a "wants"
        # dependency on ‘<foo>.service’, which is supposed to create
        # the interface and need not exist (i.e. for hardware
        # interfaces).  It has a binds-to dependency on the actual
        # network device, so it only gets started after the interface
        # has appeared, and it's stopped when the interface
        # disappears.
        configureInterface = i: nameValuePair "${i.name}-cfg"
          (let mask =
                if i.prefixLength != null then toString i.prefixLength else
                if i.subnetMask != "" then i.subnetMask else "32";
          in
          { description = "Configuration of ${i.name}";
            wantedBy = [ "network-interfaces.target" ];
            bindsTo = [ "sys-subsystem-net-devices-${i.name}.device" ];
            after = [ "sys-subsystem-net-devices-${i.name}.device" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute pkgs.gawk ];
            script =
              ''
                echo "bringing up interface..."
                ip link set "${i.name}" up
              ''
              + optionalString (i.macAddress != null)
                ''
                  echo "setting MAC address to ${i.macAddress}..."
                  ip link set "${i.name}" address "${i.macAddress}"
                ''
              + optionalString (i.ipAddress != null)
                ''
                  cur=$(ip -4 -o a show dev "${i.name}" | awk '{print $4}')
                  # Only do a flush/add if it's necessary.  This is
                  # useful when the Nix store is accessed via this
                  # interface (e.g. in a QEMU VM test).
                  if [ "$cur" != "${i.ipAddress}/${mask}" ]; then
                    echo "configuring interface..."
                    ip -4 addr flush dev "${i.name}"
                    ip -4 addr add "${i.ipAddress}/${mask}" dev "${i.name}"
                    # Ensure that the default gateway remains set.
                    # (Flushing this interface may have removed it.)
                    ${config.system.build.systemd}/bin/systemctl try-restart --no-block network-setup.service
                  else
                    echo "skipping configuring interface"
                  fi
                  ${config.system.build.systemd}/bin/systemctl start ip-up.target
                ''
              + optionalString i.proxyARP
                ''
                  echo 1 > /proc/sys/net/ipv4/conf/${i.name}/proxy_arp
                ''
              + optionalString (i.proxyARP && cfg.enableIPv6)
                ''
                  echo 1 > /proc/sys/net/ipv6/conf/${i.name}/proxy_ndp
                '';
          });

        createTunDevice = i: nameValuePair "${i.name}"
          { description = "Virtual Network Interface ${i.name}";
            requires = [ "dev-net-tun.device" ];
            after = [ "dev-net-tun.device" ];
            wantedBy = [ "network.target" "sys-subsystem-net-devices-${i.name}.device" ];
            serviceConfig =
              { Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${pkgs.tunctl}/bin/tunctl -t '${i.name}' -u '${i.virtualOwner}'";
                ExecStop = "${pkgs.tunctl}/bin/tunctl -d '${i.name}'";
              };
          };

        createBridgeDevice = n: v:
          let
            deps = map (i: "sys-subsystem-net-devices-${i}.device") v.interfaces;
          in
          { description = "Bridge Interface ${n}";
            wantedBy = [ "network.target" "sys-subsystem-net-devices-${n}.device" ];
            bindsTo = deps;
            after = deps;
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.bridge_utils pkgs.iproute ];
            script =
              ''
                brctl addbr "${n}"

                # Set bridge's hello time to 0 to avoid startup delays.
                brctl setfd "${n}" 0

                ${flip concatMapStrings v.interfaces (i: ''
                  brctl addif "${n}" "${i}"
                  ip link set "${i}" up
                  ip addr flush dev "${i}"
                '')}

                # !!! Should delete (brctl delif) any interfaces that
                # no longer belong to the bridge.
              '';
            postStop =
              ''
                ip link set "${n}" down
                brctl delbr "${n}"
              '';
          };

      in listToAttrs (
           map configureInterface interfaces ++
           map createTunDevice (filter (i: i.virtual) interfaces))
         // mapAttrs createBridgeDevice cfg.bridges
         // { "network-setup" = networkSetup; };

    # Set the host name in the activation script.  Don't clear it if
    # it's not configured in the NixOS configuration, since it may
    # have been set by dhclient in the meantime.
    system.activationScripts.hostname =
      optionalString (config.networking.hostName != "") ''
        hostname "${config.networking.hostName}"
      '';

    services.udev.extraRules =
      ''
        KERNEL=="tun", TAG+="systemd"
      '';

  };

}
