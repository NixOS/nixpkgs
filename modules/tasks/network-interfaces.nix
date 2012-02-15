{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking;

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

  };


  ###### implementation

  config = {

    boot.kernelModules = optional cfg.enableIPv6 "ipv6";

    environment.systemPackages =
      [ pkgs.host
        pkgs.iproute
        pkgs.iputils
        pkgs.nettools
        pkgs.wirelesstools
        pkgs.rfkill
      ]
      ++ optional (cfg.bridges != {}) pkgs.bridge_utils
      ++ optional cfg.enableIPv6 pkgs.ndisc6;

    security.setuidPrograms = [ "ping" "ping6" ];

    jobs.networkInterfaces =
      { name = "network-interfaces";

        startOn = "stopped udevtrigger";

        path = [ pkgs.iproute ];

        preStart =
          ''
            set +e # continue in case of errors

            ${flip concatMapStrings cfg.interfaces (i:
              optionalString (i.macAddress != "")
                ''
                  echo "Setting MAC address of ${i.name} to ${i.macAddress}..."
                  ip link set "${i.name}" address "${i.macAddress}"
                '')
            }

            for i in $(cd /sys/class/net && ls -d *); do
                echo "Bringing up network device $i..."
                ip link set "$i" up
            done

            # Create bridge devices.
            ${concatStrings (attrValues (flip mapAttrs cfg.bridges (n: v: ''
                echo "Creating bridge ${n}..."
                ${pkgs.bridge_utils}/sbin/brctl addbr "${n}"

                # Set bridge's hello time to 0 to avoid startup delays.
                ${pkgs.bridge_utils}/sbin/brctl setfd "${n}" 0

                ${flip concatMapStrings v.interfaces (i: ''
                  ${pkgs.bridge_utils}/sbin/brctl addif "${n}" "${i}"
                  ip addr flush dev "${i}"
                '')}

                # !!! Should delete (brctl delif) any interfaces that
                # no longer belong to the bridge.
            '')))}

            # Configure the manually specified interfaces.
            ${flip concatMapStrings cfg.interfaces (i:
              optionalString (i.ipAddress != "")
                ''
                  echo "Configuring interface ${i.name}..."
                  ip addr add "${i.ipAddress}""${optionalString (i.subnetMask != "") ("/" + i.subnetMask)}" \
                    dev "${i.name}"
                '')
            }

            # Set the nameservers.
            if test -n "${toString cfg.nameservers}"; then
                rm -f /etc/resolv.conf
                if test -n "${cfg.domain}"; then
                    echo "domain ${cfg.domain}" >> /etc/resolv.conf
                fi
                for i in ${toString cfg.nameservers}; do
                    echo "nameserver $i" >> /etc/resolv.conf
                done
            fi

            # Set the default gateway.
            ${optionalString (cfg.defaultGateway != "") ''
                ip route add default via "${cfg.defaultGateway}"
            ''}

            # Run any user-specified commands.
            ${pkgs.stdenv.shell} ${pkgs.writeText "local-net-cmds" cfg.localCommands}

            ${optionalString (cfg.interfaces != [] || cfg.localCommands != "") ''
              # Emit the ip-up event (e.g. to start ntpd).
              initctl emit -n ip-up
            ''}
          '';
      };

    # Set the host name in the activation script.  Don't clear it if
    # it's not configured in the NixOS configuration, since it may
    # have been set by dhclient in the meantime.
    system.activationScripts.hostname =
      optionalString (config.networking.hostName != "") ''
        hostname "${config.networking.hostName}"
      '';

  };

}
