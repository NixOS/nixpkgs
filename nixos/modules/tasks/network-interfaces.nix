{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;
  hasVirtuals = any (i: i.virtual) interfaces;
  hasSits = cfg.sits != { };
  hasBonds = cfg.bonds != { };

  # We must escape interfaces due to the systemd interpretation
  subsystemDevice = interface:
    "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";

  addrOpts = v:
    assert v == 4 || v == 6;
    {
      address = mkOption {
        type = types.str;
        description = ''
          IPv${toString v} address of the interface.  Leave empty to configure the
          interface using DHCP.
        '';
      };

      prefixLength = mkOption {
        type = types.addCheck types.int (n: n >= 0 && n <= (if v == 4 then 32 else 128));
        description = ''
          Subnet mask of the interface, specified as the number of
          bits in the prefix (<literal>${if v == 4 then "24" else "64"}</literal>).
        '';
      };
    };

  interfaceOpts = { name, ... }: {

    options = {

      name = mkOption {
        example = "eth0";
        type = types.str;
        description = "Name of the interface.";
      };

      useDHCP = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether this interface should be configured with dhcp.
          Null implies the old behavior which depends on whether ip addresses
          are specified or not.
        '';
      };

      ip4 = mkOption {
        default = [ ];
        example = [
          { address = "10.0.0.1"; prefixLength = 16; }
          { address = "192.168.1.1"; prefixLength = 24; }
        ];
        type = types.listOf types.optionSet;
        options = addrOpts 4;
        description = ''
          List of IPv4 addresses that will be statically assigned to the interface.
        '';
      };

      ip6 = mkOption {
        default = [ ];
        example = [
          { address = "fdfd:b3f0:482::1"; prefixLength = 48; }
          { address = "2001:1470:fffd:2098::e006"; prefixLength = 64; }
        ];
        type = types.listOf types.optionSet;
        options = addrOpts 6;
        description = ''
          List of IPv6 addresses that will be statically assigned to the interface.
        '';
      };

      ipAddress = mkOption {
        default = null;
        example = "10.0.0.1";
        type = types.nullOr types.str;
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
        default = null;
        description = ''
          Defunct, supply the prefix length instead.
        '';
      };

      ipv6Address = mkOption {
        default = null;
        example = "2001:1470:fffd:2098::e006";
        type = types.nullOr types.str;
        description = ''
          IPv6 address of the interface.  Leave empty to configure the
          interface using NDP.
        '';
      };

      ipv6PrefixLength = mkOption {
        default = 64;
        example = 64;
        type = types.int;
        description = ''
          Subnet mask of the interface, specified as the number of
          bits in the prefix (<literal>64</literal>).
        '';
      };

      macAddress = mkOption {
        default = null;
        example = "00:11:22:33:44:55";
        type = types.nullOr (types.str);
        description = ''
          MAC address of the interface. Leave empty to use the default.
        '';
      };

      mtu = mkOption {
        default = null;
        example = 9000;
        type = types.nullOr types.int;
        description = ''
          MTU size for packets leaving the interface. Leave empty to use the default.
        '';
      };

      virtual = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether this interface is virtual and should be created by tunctl.
          This is mainly useful for creating bridges between a host a virtual
          network such as VPN or a virtual machine.
        '';
      };

      virtualOwner = mkOption {
        default = "root";
        type = types.str;
        description = ''
          In case of a virtual device, the user who owns it.
        '';
      };

      virtualType = mkOption {
        default = null;
        type = types.nullOr (types.addCheck types.str (v: v == "tun" || v == "tap"));
        description = ''
          The explicit type of interface to create. Accepts tun or tap strings.
          Also accepts null to implicitly detect the type of device.
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

  hexChars = stringToCharacters "0123456789abcdef";

  isHexString = s: all (c: elem c hexChars) (stringToCharacters (toLower s));

in

{

  ###### interface

  options = {

    networking.hostName = mkOption {
      default = "nixos";
      type = types.str;
      description = ''
        The name of the machine.  Leave it empty if you want to obtain
        it from a DHCP server (if using DHCP).
      '';
    };

    networking.hostId = mkOption {
      default = null;
      example = "4e98920d";
      type = types.nullOr types.str;
      description = ''
        The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.

        You should try to make this ID unique among your machines. You can
        generate a random 32-bit ID using the following command:

        <literal>head -c4 /dev/urandom | od -A none -t x4</literal>
      '';
    };

    networking.enableIPv6 = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable support for IPv6.
      '';
    };

    networking.defaultGateway = mkOption {
      default = null;
      example = "131.211.84.1";
      type = types.nullOr types.str;
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

    networking.search = mkOption {
      default = [];
      example = [ "example.com" "local.domain" ];
      type = types.listOf types.str;
      description = ''
        The list of search paths used when resolving domain names.
      '';
    };

    networking.domain = mkOption {
      default = null;
      example = "home";
      type = types.nullOr types.str;
      description = ''
        The domain.  It can be left empty if it is auto-detected through DHCP.
      '';
    };

    networking.useHostResolvConf = mkOption {
      type = types.bool;
      default = false;
      description = ''
        In containers, whether to use the
        <filename>resolv.conf</filename> supplied by the host.
      '';
    };

    networking.localCommands = mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = ''
        Shell commands to be executed at the end of the
        <literal>network-setup</literal> systemd service.  Note that if
        you are using DHCP to obtain the network configuration,
        interfaces may not be fully configured yet.
      '';
    };

    networking.interfaces = mkOption {
      default = {};
      example =
        { eth0.ip4 = [ {
            address = "131.211.84.78";
            prefixLength = 25;
          } ];
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

    networking.bonds = mkOption {
      default = { };
      example = {
        bond0 = {
          interfaces = [ "eth0" "wlan0" ];
          miimon = 100;
          mode = "active-backup";
        };
        fatpipe.interfaces = [ "enp4s0f0" "enp4s0f1" "enp5s0f0" "enp5s0f1" ];
      };
      description = ''
        This option allows you to define bond devices that aggregate multiple,
        underlying networking interfaces together. The value of this option is
        an attribute set. Each attribute specifies a bond, with the attribute
        name specifying the name of the bond's network interface
      '';

      type = types.attrsOf types.optionSet;

      options = {

        interfaces = mkOption {
          example = [ "enp4s0f0" "enp4s0f1" "wlan0" ];
          type = types.listOf types.str;
          description = "The interfaces to bond together";
        };

        lacp_rate = mkOption {
          default = null;
          example = "fast";
          type = types.nullOr types.str;
          description = ''
            Option specifying the rate in which we'll ask our link partner
            to transmit LACPDU packets in 802.3ad mode.
          '';
        };

        miimon = mkOption {
          default = null;
          example = 100;
          type = types.nullOr types.int;
          description = ''
            Miimon is the number of millisecond in between each round of polling
            by the device driver for failed links. By default polling is not
            enabled and the driver is trusted to properly detect and handle
            failure scenarios.
          '';
        };

        mode = mkOption {
          default = null;
          example = "active-backup";
          type = types.nullOr types.str;
          description = ''
            The mode which the bond will be running. The default mode for
            the bonding driver is balance-rr, optimizing for throughput.
            More information about valid modes can be found at
            https://www.kernel.org/doc/Documentation/networking/bonding.txt
          '';
        };

        xmit_hash_policy = mkOption {
          default = null;
          example = "layer2+3";
          type = types.nullOr types.str;
          description = ''
            Selects the transmit hash policy to use for slave selection in
            balance-xor, 802.3ad, and tlb modes.
          '';
        };

      };
    };

    networking.macvlans = mkOption {
      type = types.attrsOf types.optionSet;
      default = { };
      example = {
        wan = {
          interface = "enp2s0";
          mode = "vepa";
        };
      };
      description = ''
        This option allows you to define macvlan interfaces which should
        be automatically created.
      '';
      options = {

        interface = mkOption {
          example = "enp4s0";
          type = types.string;
          description = "The interface the macvlan will transmit packets through.";
        };

        mode = mkOption {
          default = null;
          type = types.nullOr types.str;
          example = "vepa";
          description = "The mode of the macvlan device.";
        };

      };
    };

    networking.sits = mkOption {
      type = types.attrsOf types.optionSet;
      default = { };
      example = {
        hurricane = {
          remote = "10.0.0.1";
          local = "10.0.0.22";
          ttl = 255;
        };
        msipv6 = {
          remote = "192.168.0.1";
          dev = "enp3s0";
          ttl = 127;
        };
      };
      description = ''
        This option allows you to define 6-to-4 interfaces which should be automatically created.
      '';
      options = {

        remote = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "10.0.0.1";
          description = ''
            The address of the remote endpoint to forward traffic over.
          '';
        };

        local = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "10.0.0.22";
          description = ''
            The address of the local endpoint which the remote
            side should send packets to.
          '';
        };

        ttl = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 255;
          description = ''
            The time-to-live of the connection to the remote tunnel endpoint.
          '';
        };

        dev = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "enp4s0f0";
          description = ''
            The underlying network device on which the tunnel resides.
          '';
        };

      };
    };

    networking.vlans = mkOption {
      default = { };
      example = {
        vlan0 = {
          id = 3;
          interface = "enp3s0";
        };
        vlan1 = {
          id = 1;
          interface = "wlan0";
        };
      };
      description =
        ''
          This option allows you to define vlan devices that tag packets
          on top of a physical interface. The value of this option is an
          attribute set. Each attribute specifies a vlan, with the name
          specifying the name of the vlan interface.
        '';

      type = types.attrsOf types.optionSet;

      options = {

        id = mkOption {
          example = 1;
          type = types.int;
          description = "The vlan identifier";
        };

        interface = mkOption {
          example = "enp4s0";
          type = types.string;
          description = "The interface the vlan will transmit packets through.";
        };

      };
    };

    networking.useDHCP = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use DHCP to obtain an IP address and other
        configuration for all network interfaces that are not manually
        configured.
      '';
    };

    networking.useNetworkd = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether we should use networkd as the network configuration backend or
        the legacy script based system. Note that this option is experimental,
        enable at your own risk.
      '';
    };

  };


  ###### implementation

  config = {

    assertions =
      (flip map interfaces (i: {
        assertion = i.subnetMask == null;
        message = "The networking.interfaces.${i.name}.subnetMask option is defunct. Use prefixLength instead.";
      })) ++ [
        {
          assertion = cfg.hostId == null || (stringLength cfg.hostId == 8 && isHexString cfg.hostId);
          message = "Invalid value given to the networking.hostId option.";
        }
      ];

    boot.kernelModules = [ ]
      ++ optional cfg.enableIPv6 "ipv6"
      ++ optional hasVirtuals "tun"
      ++ optional hasSits "sit"
      ++ optional hasBonds "bonding";

    boot.extraModprobeConfig =
      # This setting is intentional as it prevents default bond devices
      # from being created.
      optionalString hasBonds "options bonding max_bonds=0";

    boot.kernel.sysctl = {
      "net.net.ipv4.conf.all.promote_secondaries" = true;
      "net.ipv6.conf.all.disable_ipv6" = mkDefault (!cfg.enableIPv6);
      "net.ipv6.conf.default.disable_ipv6" = mkDefault (!cfg.enableIPv6);
      "net.ipv4.conf.all_forwarding" = mkDefault (any (i: i.proxyARP) interfaces);
      "net.ipv6.conf.all.forwarding" = mkDefault (any (i: i.proxyARP) interfaces);
    } // listToAttrs (concatLists (flip map (filter (i: i.proxyARP) interfaces)
        (i: flip map [ "4" "6" ] (v: nameValuePair "net.ipv${v}.conf.${i.name}.proxy_arp" true))
      ));

    security.setuidPrograms = [ "ping" "ping6" ];

    # Set the host and domain names in the activation script.  Don't
    # clear it if it's not configured in the NixOS configuration,
    # since it may have been set by dhcpcd in the meantime.
    system.activationScripts.hostname =
      optionalString (cfg.hostName != "") ''
        hostname "${cfg.hostName}"
      '';
    system.activationScripts.domain =
      optionalString (cfg.domain != null) ''
        domainname "${cfg.domain}"
      '';

    environment.etc = mkIf (cfg.hostId != null)
      [
        {
          target = "hostid";
          source = pkgs.runCommand "gen-hostid" {} ''
            hi="${cfg.hostId}"
            ${if pkgs.stdenv.isBigEndian then ''
              echo -ne "\x''${hi:0:2}\x''${hi:2:2}\x''${hi:4:2}\x''${hi:6:2}" > $out
            '' else ''
              echo -ne "\x''${hi:6:2}\x''${hi:4:2}\x''${hi:2:2}\x''${hi:0:2}" > $out
            ''}
          '';
        }
      ];

    environment.systemPackages =
      [ pkgs.host
        pkgs.iproute
        pkgs.iputils
        pkgs.nettools
        pkgs.wirelesstools
        pkgs.iw
        pkgs.rfkill
        pkgs.openresolv
      ];

    systemd.services = {
      network-local-commands = {
        description = "Extra networking commands.";
        before = [ "network.target" ];
        wantedBy = [ "network.target" ];
        unitConfig.ConditionCapability = "CAP_NET_ADMIN";
        path = [ pkgs.iproute ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          # Run any user-specified commands.
          ${cfg.localCommands}
        '';
      };
    } // (listToAttrs (flip map interfaces (i:
      nameValuePair "network-link-${i.name}"
      { description = "Link configuration of ${i.name}";
        wantedBy = [ "network-interfaces.target" ];
        before = [ "network-interfaces.target" ];
        bindsTo = [ (subsystemDevice i.name) ];
        after = [ (subsystemDevice i.name) ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script =
          ''
            echo "Configuring link..."
          '' + optionalString (i.macAddress != null) ''
            echo "setting MAC address to ${i.macAddress}..."
            ip link set "${i.name}" address "${i.macAddress}"
          '' + optionalString (i.mtu != null) ''
            echo "setting MTU to ${toString i.mtu}..."
            ip link set "${i.name}" mtu "${toString i.mtu}"
          '';
      })));
  };

}
