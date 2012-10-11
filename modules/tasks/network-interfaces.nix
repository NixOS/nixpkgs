{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking;
  hasVirtuals = any (i: i.virtual) cfg.interfaces;

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
      default = [];
      example = [
        { name = "eth0";
          ipAddress = "131.211.84.78";
          subnetMask = "255.255.255.128";
        }
      ];
      description = ''
        The configuration for each network interface.  If
        <option>networking.useDHCP</option> is true, then every
        interface not listed here will be configured using DHCP.
      '';

      type = types.list types.optionSet;

      options = {

        name = mkOption {
          example = "eth0";
          type = types.string;
          description = ''
            Name of the interface.
          '';
        };

        ipAddress = mkOption {
          default = "";
          example = "10.0.0.1";
          type = types.string;
          description = ''
            IP address of the interface.  Leave empty to configure the
            interface using DHCP.
          '';
        };

        subnetMask = mkOption {
          default = "";
          example = "255.255.255.0";
          type = types.string;
          description = ''
            Subnet mask of the interface.  Leave empty to use the
            default subnet mask.
          '';
        };

        macAddress = mkOption {
          default = "";
          example = "00:11:22:33:44:55";
          type = types.string;
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

    };

    networking.ifaces = mkOption {
      default = listToAttrs
        (map (iface: { name = iface.name; value = iface; }) config.networking.interfaces);
      internal = true;
      description = ''
        The network interfaces in <option>networking.interfaces</option>
        as an attribute set keyed on the interface name.
      '';
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

    jobs."network-interfaces" =
      { description = "Static Network Interfaces";

        after = [ "systemd-udev-settle.service" ];
        before = [ "network.target" ];
        wantedBy = [ "network.target" ];

        path = [ pkgs.iproute ];

        preStart =
          ''
            set +e # continue in case of errors

            # Set the static DNS configuration, if given.
            cat | ${pkgs.openresolv}/sbin/resolvconf -a static <<EOF
            ${optionalString (cfg.nameservers != [] && cfg.domain != "") ''
              domain ${cfg.domain}
            ''}
            ${flip concatMapStrings cfg.nameservers (ns: ''
              nameserver ${ns}
            '')}
            EOF

            # Set the default gateway.
            ${optionalString (cfg.defaultGateway != "") ''
              ip route add default via "${cfg.defaultGateway}"
            ''}

            # Turn on forwarding if any interface has enabled proxy_arp.
            ${optionalString (any (i: i.proxyARP) cfg.interfaces) ''
              echo 1 > /proc/sys/net/ipv4/ip_forward
            ''}

            # Run any user-specified commands.
            ${pkgs.stdenv.shell} ${pkgs.writeText "local-net-cmds" cfg.localCommands}
          '';
      };

    boot.systemd.services =
      let

        # For each interface <foo>, create a job ‘<foo>-cfg.service"
        # that performs static configuration.  It has a "wants"
        # dependency on ‘<foo>.service’, which is supposed to create
        # the interface and need not exist (i.e. for hardware
        # interfaces).  It has a binds-to dependency on the actual
        # network device, so it only gets started after the interface
        # has appeared, and it's stopped when the interface
        # disappears.
        configureInterface = i: nameValuePair "${i.name}-cfg"
          { description = "Configuration of ${i.name}";
            wantedBy = [ "network.target" ];
            bindsTo = [ "sys-subsystem-net-devices-${i.name}.device" ];
            after = [ "sys-subsystem-net-devices-${i.name}.device" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script =
              ''
                echo "bringing up interface..."
                ip link set "${i.name}" up
              ''
              + optionalString (i.macAddress != "")
                ''
                  echo "setting MAC address to ${i.macAddress}..."
                  ip link set "${i.name}" address "${i.macAddress}"
                ''
              + optionalString (i.ipAddress != "")
                ''
                  echo "configuring interface..."
                  ip addr flush dev "${i.name}"
                  ip addr add "${i.ipAddress}""${optionalString (i.subnetMask != "") ("/" + i.subnetMask)}" \
                    dev "${i.name}"
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
          };

        createTunDevice = i: nameValuePair "${i.name}"
          { description = "Virtual Network Interface ${i.name}";
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
           map configureInterface cfg.interfaces ++
           map createTunDevice (filter (i: i.virtual) cfg.interfaces))
         // mapAttrs createBridgeDevice cfg.bridges;

    # Set the host name in the activation script.  Don't clear it if
    # it's not configured in the NixOS configuration, since it may
    # have been set by dhclient in the meantime.
    system.activationScripts.hostname =
      optionalString (config.networking.hostName != "") ''
        hostname "${config.networking.hostName}"
      '';

  };

}
