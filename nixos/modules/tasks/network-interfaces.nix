{ config, options, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;
  hasVirtuals = any (i: i.virtual) interfaces;
  hasSits = cfg.sits != { };
  hasBonds = cfg.bonds != { };

  slaves = concatMap (i: i.interfaces) (attrValues cfg.bonds)
    ++ concatMap (i: i.interfaces) (attrValues cfg.bridges)
    ++ concatMap (i: attrNames (filterAttrs (name: config: ! (config.type == "internal" || hasAttr name cfg.interfaces)) i.interfaces)) (attrValues cfg.vswitches);

  slaveIfs = map (i: cfg.interfaces.${i}) (filter (i: cfg.interfaces ? ${i}) slaves);

  rstpBridges = flip filterAttrs cfg.bridges (_: { rstp, ... }: rstp);

  needsMstpd = rstpBridges != { };

  bridgeStp = optional needsMstpd (pkgs.writeTextFile {
    name = "bridge-stp";
    executable = true;
    destination = "/bin/bridge-stp";
    text = ''
      #!${pkgs.runtimeShell} -e
      export PATH="${pkgs.mstpd}/bin"

      BRIDGES=(${concatStringsSep " " (attrNames rstpBridges)})
      for BRIDGE in $BRIDGES; do
        if [ "$BRIDGE" = "$1" ]; then
          if [ "$2" = "start" ]; then
            mstpctl addbridge "$BRIDGE"
            exit 0
          elif [ "$2" = "stop" ]; then
            mstpctl delbridge "$BRIDGE"
            exit 0
          fi
          exit 1
        fi
      done
      exit 1
    '';
  });

  # We must escape interfaces due to the systemd interpretation
  subsystemDevice = interface:
    "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";

  addrOpts = v:
    assert v == 4 || v == 6;
    { options = {
        address = mkOption {
          type = types.str;
          description = ''
            IPv${toString v} address of the interface. Leave empty to configure the
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
    };

  routeOpts = v:
  { options = {
      address = mkOption {
        type = types.str;
        description = "IPv${toString v} address of the network.";
      };

      prefixLength = mkOption {
        type = types.addCheck types.int (n: n >= 0 && n <= (if v == 4 then 32 else 128));
        description = ''
          Subnet mask of the network, specified as the number of
          bits in the prefix (<literal>${if v == 4 then "24" else "64"}</literal>).
        '';
      };

      via = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "IPv${toString v} address of the next hop.";
      };

      options = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = { mtu = "1492"; window = "524288"; };
        description = ''
          Other route options. See the symbol <literal>OPTIONS</literal>
          in the <literal>ip-route(8)</literal> manual page for the details.
        '';
      };

    };
  };

  gatewayCoerce = address: { inherit address; };

  gatewayOpts = { ... }: {

    options = {

      address = mkOption {
        type = types.str;
        description = "The default gateway address.";
      };

      interface = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "enp0s3";
        description = "The default gateway interface.";
      };

      metric = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 42;
        description = "The default gateway metric/preference.";
      };

    };

  };

  interfaceOpts = { name, ... }: {

    options = {
      name = mkOption {
        example = "eth0";
        type = types.str;
        description = "Name of the interface.";
      };

      tempAddress = mkOption {
        type = types.enum [ "default" "enabled" "disabled" ];
        default = if cfg.enableIPv6 then "default" else "disabled";
        defaultText = literalExample ''if cfg.enableIPv6 then "default" else "disabled"'';
        description = ''
          When IPv6 is enabled with SLAAC, this option controls the use of
          temporary address (aka privacy extensions). This is used to reduce tracking.
          The three possible values are:

          <itemizedlist>
           <listitem>
            <para>
             <literal>"default"</literal> to generate temporary addresses and use
             them by default;
            </para>
           </listitem>
           <listitem>
            <para>
             <literal>"enabled"</literal> to generate temporary addresses but keep
             using the standard EUI-64 ones by default;
            </para>
           </listitem>
           <listitem>
            <para>
             <literal>"disabled"</literal> to completely disable temporary addresses.
            </para>
           </listitem>
          </itemizedlist>
        '';
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

      ipv4.addresses = mkOption {
        default = [ ];
        example = [
          { address = "10.0.0.1"; prefixLength = 16; }
          { address = "192.168.1.1"; prefixLength = 24; }
        ];
        type = with types; listOf (submodule (addrOpts 4));
        description = ''
          List of IPv4 addresses that will be statically assigned to the interface.
        '';
      };

      ipv6.addresses = mkOption {
        default = [ ];
        example = [
          { address = "fdfd:b3f0:482::1"; prefixLength = 48; }
          { address = "2001:1470:fffd:2098::e006"; prefixLength = 64; }
        ];
        type = with types; listOf (submodule (addrOpts 6));
        description = ''
          List of IPv6 addresses that will be statically assigned to the interface.
        '';
      };

      ipv4.routes = mkOption {
        default = [];
        example = [
          { address = "10.0.0.0"; prefixLength = 16; }
          { address = "192.168.2.0"; prefixLength = 24; via = "192.168.1.1"; }
        ];
        type = with types; listOf (submodule (routeOpts 4));
        description = ''
          List of extra IPv4 static routes that will be assigned to the interface.
        '';
      };

      ipv6.routes = mkOption {
        default = [];
        example = [
          { address = "fdfd:b3f0::"; prefixLength = 48; }
          { address = "2001:1470:fffd:2098::"; prefixLength = 64; via = "fdfd:b3f0::1"; }
        ];
        type = with types; listOf (submodule (routeOpts 6));
        description = ''
          List of extra IPv6 static routes that will be assigned to the interface.
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
          This is mainly useful for creating bridges between a host and a virtual
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
        default = if hasPrefix "tun" name then "tun" else "tap";
        defaultText = literalExample ''if hasPrefix "tun" name then "tun" else "tap"'';
        type = with types; enum [ "tun" "tap" ];
        description = ''
          The type of interface to create.
          The default is TUN for an interface name starting
          with "tun", otherwise TAP.
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

    # Renamed or removed options
    imports =
      let
        defined = x: x != "_mkMergedOptionModule";
      in [
        (mkChangedOptionModule [ "preferTempAddress" ] [ "tempAddress" ]
         (config:
          let bool = getAttrFromPath [ "preferTempAddress" ] config;
          in if bool then "default" else "enabled"
        ))
        (mkRenamedOptionModule [ "ip4" ] [ "ipv4" "addresses"])
        (mkRenamedOptionModule [ "ip6" ] [ "ipv6" "addresses"])
        (mkRemovedOptionModule [ "subnetMask" ] ''
          Supply a prefix length instead; use option
          networking.interfaces.<name>.ipv{4,6}.addresses'')
        (mkMergedOptionModule
          [ [ "ipAddress" ] [ "prefixLength" ] ]
          [ "ipv4" "addresses" ]
          (cfg: with cfg;
            optional (defined ipAddress && defined prefixLength)
            { address = ipAddress; prefixLength = prefixLength; }))
        (mkMergedOptionModule
          [ [ "ipv6Address" ] [ "ipv6PrefixLength" ] ]
          [ "ipv6" "addresses" ]
          (cfg: with cfg;
            optional (defined ipv6Address && defined ipv6PrefixLength)
            { address = ipv6Address; prefixLength = ipv6PrefixLength; }))

        ({ options.warnings = options.warnings; options.assertions = options.assertions; })
      ];

  };

  vswitchInterfaceOpts = {name, ...}: {

    options = {

      name = mkOption {
        description = "Name of the interface";
        example = "eth0";
        type = types.str;
      };

      vlan = mkOption {
        description = "Vlan tag to apply to interface";
        example = 10;
        type = types.nullOr types.int;
        default = null;
      };

      type = mkOption {
        description = "Openvswitch type to assign to interface";
        example = "internal";
        type = types.nullOr types.str;
        default = null;
      };
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
        generate a random 32-bit ID using the following commands:

        <literal>head -c 8 /etc/machine-id</literal>

        (this derives it from the machine-id that systemd generates) or

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
      example = {
        address = "131.211.84.1";
        interface = "enp3s0";
      };
      type = types.nullOr (types.coercedTo types.str gatewayCoerce (types.submodule gatewayOpts));
      description = ''
        The default gateway. It can be left empty if it is auto-detected through DHCP.
        It can be specified as a string or an option set along with a network interface.
      '';
    };

    networking.defaultGateway6 = mkOption {
      default = null;
      example = {
        address = "2001:4d0:1e04:895::1";
        interface = "enp3s0";
      };
      type = types.nullOr (types.coercedTo types.str gatewayCoerce (types.submodule gatewayOpts));
      description = ''
        The default ipv6 gateway. It can be left empty if it is auto-detected through DHCP.
        It can be specified as a string or an option set along with a network interface.
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
      type = types.listOf types.str;
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
      type = types.lines;
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
        { eth0.ipv4.addresses = [ {
            address = "131.211.84.78";
            prefixLength = 25;
          } ];
        };
      description = ''
        The configuration for each network interface.  If
        <option>networking.useDHCP</option> is true, then every
        interface not listed here will be configured using DHCP.
      '';
      type = with types; loaOf (submodule interfaceOpts);
    };

    networking.vswitches = mkOption {
      default = { };
      example =
        { vs0.interfaces = { eth0 = { }; lo1 = { type="internal"; }; };
          vs1.interfaces = [ { name = "eth2"; } { name = "lo2"; type="internal"; } ];
        };
      description =
        ''
          This option allows you to define Open vSwitches that connect
          physical networks together. The value of this option is an
          attribute set. Each attribute specifies a vswitch, with the
          attribute name specifying the name of the vswitch's network
          interface.
        '';

      type = with types; attrsOf (submodule {

        options = {

          interfaces = mkOption {
            example = [ "eth0" "eth1" ];
            description = "The physical network interfaces connected by the vSwitch.";
            type = with types; loaOf (submodule vswitchInterfaceOpts);
          };

          controllers = mkOption {
            type = types.listOf types.str;
            default = [];
            example = [ "ptcp:6653:[::1]" ];
            description = ''
              Specify the controller targets. For the allowed options see <literal>man 8 ovs-vsctl</literal>.
            '';
          };

          openFlowRules = mkOption {
            type = types.lines;
            default = "";
            example = ''
              actions=normal
            '';
            description = ''
              OpenFlow rules to insert into the Open vSwitch. All <literal>openFlowRules</literal> are
              loaded with <literal>ovs-ofctl</literal> within one atomic operation.
            '';
          };

          # TODO: custom "openflow version" type, with list from existing openflow protocols
          supportedOpenFlowVersions = mkOption {
            type = types.listOf types.str;
            example = [ "OpenFlow10" "OpenFlow13" "OpenFlow14" ];
            default = [ "OpenFlow13" ];
            description = ''
              Supported versions to enable on this switch.
            '';
          };

          # TODO: use same type as elements from supportedOpenFlowVersions
          openFlowVersion = mkOption {
            type = types.str;
            default = "OpenFlow13";
            description = ''
              Version of OpenFlow protocol to use when communicating with the switch internally (e.g. with <literal>openFlowRules</literal>).
            '';
          };

          extraOvsctlCmds = mkOption {
            type = types.lines;
            default = "";
            example = ''
              set-fail-mode <switch_name> secure
              set Bridge <switch_name> stp_enable=true
            '';
            description = ''
              Commands to manipulate the Open vSwitch database. Every line executed with <literal>ovs-vsctl</literal>.
              All commands are bundled together with the operations for adding the interfaces
              into one atomic operation.
            '';
          };

        };

      });

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

      type = with types; attrsOf (submodule {

        options = {

          interfaces = mkOption {
            example = [ "eth0" "eth1" ];
            type = types.listOf types.str;
            description =
              "The physical network interfaces connected by the bridge.";
          };

          rstp = mkOption {
            default = false;
            type = types.bool;
            description = "Whether the bridge interface should enable rstp.";
          };

        };

      });

    };

    networking.bonds =
      let
        driverOptionsExample = {
          miimon = "100";
          mode = "active-backup";
        };
      in mkOption {
        default = { };
        example = literalExample {
          bond0 = {
            interfaces = [ "eth0" "wlan0" ];
            driverOptions = driverOptionsExample;
          };
          anotherBond.interfaces = [ "enp4s0f0" "enp4s0f1" "enp5s0f0" "enp5s0f1" ];
        };
        description = ''
          This option allows you to define bond devices that aggregate multiple,
          underlying networking interfaces together. The value of this option is
          an attribute set. Each attribute specifies a bond, with the attribute
          name specifying the name of the bond's network interface
        '';

        type = with types; attrsOf (submodule {

          options = {

            interfaces = mkOption {
              example = [ "enp4s0f0" "enp4s0f1" "wlan0" ];
              type = types.listOf types.str;
              description = "The interfaces to bond together";
            };

            driverOptions = mkOption {
              type = types.attrsOf types.str;
              default = {};
              example = literalExample driverOptionsExample;
              description = ''
                Options for the bonding driver.
                Documentation can be found in
                <link xlink:href="https://www.kernel.org/doc/Documentation/networking/bonding.txt" />
              '';

            };

            lacp_rate = mkOption {
              default = null;
              example = "fast";
              type = types.nullOr types.str;
              description = ''
                DEPRECATED, use `driverOptions`.
                Option specifying the rate in which we'll ask our link partner
                to transmit LACPDU packets in 802.3ad mode.
              '';
            };

            miimon = mkOption {
              default = null;
              example = 100;
              type = types.nullOr types.int;
              description = ''
                DEPRECATED, use `driverOptions`.
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
                DEPRECATED, use `driverOptions`.
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
                DEPRECATED, use `driverOptions`.
                Selects the transmit hash policy to use for slave selection in
                balance-xor, 802.3ad, and tlb modes.
              '';
            };

          };

        });
      };

    networking.macvlans = mkOption {
      default = { };
      example = literalExample {
        wan = {
          interface = "enp2s0";
          mode = "vepa";
        };
      };
      description = ''
        This option allows you to define macvlan interfaces which should
        be automatically created.
      '';
      type = with types; attrsOf (submodule {
        options = {

          interface = mkOption {
            example = "enp4s0";
            type = types.str;
            description = "The interface the macvlan will transmit packets through.";
          };

          mode = mkOption {
            default = null;
            type = types.nullOr types.str;
            example = "vepa";
            description = "The mode of the macvlan device.";
          };

        };

      });
    };

    networking.sits = mkOption {
      default = { };
      example = literalExample {
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
      type = with types; attrsOf (submodule {
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

      });
    };

    networking.vlans = mkOption {
      default = { };
      example = literalExample {
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

      type = with types; attrsOf (submodule {

        options = {

          id = mkOption {
            example = 1;
            type = types.int;
            description = "The vlan identifier";
          };

          interface = mkOption {
            example = "enp4s0";
            type = types.str;
            description = "The interface the vlan will transmit packets through.";
          };

        };

      });

    };

    networking.wlanInterfaces = mkOption {
      default = { };
      example = literalExample {
        wlan-station0 = {
            device = "wlp6s0";
        };
        wlan-adhoc0 = {
            type = "ibss";
            device = "wlp6s0";
            mac = "02:00:00:00:00:01";
        };
        wlan-p2p0 = {
            device = "wlp6s0";
            mac = "02:00:00:00:00:02";
        };
        wlan-ap0 = {
            device = "wlp6s0";
            mac = "02:00:00:00:00:03";
        };
      };
      description =
        ''
          Creating multiple WLAN interfaces on top of one physical WLAN device (NIC).

          The name of the WLAN interface corresponds to the name of the attribute.
          A NIC is referenced by the persistent device name of the WLAN interface that
          <literal>udev</literal> assigns to a NIC by default.
          If a NIC supports multiple WLAN interfaces, then the one NIC can be used as
          <literal>device</literal> for multiple WLAN interfaces.
          If a NIC is used for creating WLAN interfaces, then the default WLAN interface
          with a persistent device name form <literal>udev</literal> is not created.
          A WLAN interface with the persistent name assigned from <literal>udev</literal>
          would have to be created explicitly.
        '';

      type = with types; attrsOf (submodule {

        options = {

          device = mkOption {
            type = types.str;
            example = "wlp6s0";
            description = "The name of the underlying hardware WLAN device as assigned by <literal>udev</literal>.";
          };

          type = mkOption {
            type = types.enum [ "managed" "ibss" "monitor" "mesh" "wds" ];
            default = "managed";
            example = "ibss";
            description = ''
              The type of the WLAN interface.
              The type has to be supported by the underlying hardware of the device.
            '';
          };

          meshID = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "MeshID of interface with type <literal>mesh</literal>.";
          };

          flags = mkOption {
            type = with types; nullOr (enum [ "none" "fcsfail" "control" "otherbss" "cook" "active" ]);
            default = null;
            example = "control";
            description = ''
              Flags for interface of type <literal>monitor</literal>.
            '';
          };

          fourAddr = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = "Whether to enable <literal>4-address mode</literal> with type <literal>managed</literal>.";
          };

          mac = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "02:00:00:00:00:01";
            description = ''
              MAC address to use for the device. If <literal>null</literal>, then the MAC of the
              underlying hardware WLAN device is used.

              INFO: Locally administered MAC addresses are of the form:
              <itemizedlist>
              <listitem><para>x2:xx:xx:xx:xx:xx</para></listitem>
              <listitem><para>x6:xx:xx:xx:xx:xx</para></listitem>
              <listitem><para>xA:xx:xx:xx:xx:xx</para></listitem>
              <listitem><para>xE:xx:xx:xx:xx:xx</para></listitem>
              </itemizedlist>
            '';
          };

        };

      });

    };

    networking.useDHCP = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use DHCP to obtain an IP address and other
        configuration for all network interfaces that are not manually
        configured.

        Using this option is highly discouraged and also incompatible with
        <option>networking.useNetworkd</option>. Please use
        <option>networking.interfaces.&lt;name&gt;.useDHCP</option> instead
        and set this to false.
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

    warnings = concatMap (i: i.warnings) interfaces;

    assertions =
      (forEach interfaces (i: {
        # With the linux kernel, interface name length is limited by IFNAMSIZ
        # to 16 bytes, including the trailing null byte.
        # See include/linux/if.h in the kernel sources
        assertion = stringLength i.name < 16;
        message = ''
          The name of networking.interfaces."${i.name}" is too long, it needs to be less than 16 characters.
        '';
      })) ++ (forEach slaveIfs (i: {
        assertion = i.ipv4.addresses == [ ] && i.ipv6.addresses == [ ];
        message = ''
          The networking.interfaces."${i.name}" must not have any defined ips when it is a slave.
        '';
      })) ++ (forEach interfaces (i: {
        assertion = i.tempAddress != "disabled" -> cfg.enableIPv6;
        message = ''
          Temporary addresses are only needed when IPv6 is enabled.
        '';
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
      "net.ipv6.conf.all.disable_ipv6" = mkDefault (!cfg.enableIPv6);
      "net.ipv6.conf.default.disable_ipv6" = mkDefault (!cfg.enableIPv6);
      "net.ipv6.conf.all.forwarding" = mkDefault (any (i: i.proxyARP) interfaces);
    } // listToAttrs (flip concatMap (filter (i: i.proxyARP) interfaces)
        (i: forEach [ "4" "6" ] (v: nameValuePair "net.ipv${v}.conf.${replaceChars ["."] ["/"] i.name}.proxy_arp" true)))
      // listToAttrs (forEach interfaces
        (i: let
          opt = i.tempAddress;
          val = { disabled = 0; enabled = 1; default = 2; }.${opt};
         in nameValuePair "net.ipv6.conf.${replaceChars ["."] ["/"] i.name}.use_tempaddr" val));

    # Capabilities won't work unless we have at-least a 4.3 Linux
    # kernel because we need the ambient capability
    security.wrappers = if (versionAtLeast (getVersion config.boot.kernelPackages.kernel) "4.3") then {
      ping = {
        source  = "${pkgs.iputils.out}/bin/ping";
        capabilities = "cap_net_raw+p";
      };
    } else {
      ping.source = "${pkgs.iputils.out}/bin/ping";
    };

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

    environment.etc.hostid = mkIf (cfg.hostId != null)
      { source = pkgs.runCommand "gen-hostid" { preferLocalBuild = true; } ''
          hi="${cfg.hostId}"
          ${if pkgs.stdenv.isBigEndian then ''
            echo -ne "\x''${hi:0:2}\x''${hi:2:2}\x''${hi:4:2}\x''${hi:6:2}" > $out
          '' else ''
            echo -ne "\x''${hi:6:2}\x''${hi:4:2}\x''${hi:2:2}\x''${hi:0:2}" > $out
          ''}
        '';
      };

    # static hostname configuration needed for hostnamectl and the
    # org.freedesktop.hostname1 dbus service (both provided by systemd)
    environment.etc.hostname = mkIf (cfg.hostName != "")
      {
        text = cfg.hostName + "\n";
      };

    environment.systemPackages =
      [ pkgs.host
        pkgs.iproute
        pkgs.iputils
        pkgs.nettools
      ]
      ++ optionals config.networking.wireless.enable [
        pkgs.wirelesstools # FIXME: obsolete?
        pkgs.iw
        pkgs.rfkill
      ]
      ++ bridgeStp;

    # The network-interfaces target is kept for backwards compatibility.
    # New modules must NOT use it.
    systemd.targets.network-interfaces =
      { description = "All Network Interfaces (deprecated)";
        wantedBy = [ "network.target" ];
        before = [ "network.target" ];
        after = [ "network-pre.target" ];
        unitConfig.X-StopOnReconfiguration = true;
      };

    systemd.services = {
      network-local-commands = {
        description = "Extra networking commands.";
        before = [ "network.target" ];
        wantedBy = [ "network.target" ];
        after = [ "network-pre.target" ];
        unitConfig.ConditionCapability = "CAP_NET_ADMIN";
        path = [ pkgs.iproute ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          # Run any user-specified commands.
          ${cfg.localCommands}
        '';
      };
    } // (listToAttrs (forEach interfaces (i:
      let
        deviceDependency = if (config.boot.isContainer || i.name == "lo")
          then []
          else [ (subsystemDevice i.name) ];
      in
      nameValuePair "network-link-${i.name}"
      { description = "Link configuration of ${i.name}";
        wantedBy = [ "network-interfaces.target" ];
        before = [ "network-interfaces.target" ];
        bindsTo = deviceDependency;
        after = [ "network-pre.target" ] ++ deviceDependency;
        path = [ pkgs.iproute ];
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
          '' + ''
            echo -n "bringing up interface... "
            ip link set "${i.name}" up && echo "done" || (echo "failed"; exit 1)
          '';
      })));

    services.mstpd = mkIf needsMstpd { enable = true; };

    virtualisation.vswitch = mkIf (cfg.vswitches != { }) { enable = true; };

    services.udev.packages =  [
      (pkgs.writeTextFile rec {
        name = "ipv6-privacy-extensions.rules";
        destination = "/etc/udev/rules.d/98-${name}";
        text = ''
          # enable and prefer IPv6 privacy addresses by default
          ACTION=="add", SUBSYSTEM=="net", RUN+="${pkgs.bash}/bin/sh -c 'echo 2 > /proc/sys/net/ipv6/conf/%k/use_tempaddr'"
        '';
      })
      (pkgs.writeTextFile rec {
        name = "ipv6-privacy-extensions.rules";
        destination = "/etc/udev/rules.d/99-${name}";
        text = concatMapStrings (i:
          let
            opt = i.tempAddress;
            val = if opt == "disabled" then 0 else 1;
            msg = if opt == "disabled"
                  then "completely disable IPv6 privacy addresses"
                  else "enable IPv6 privacy addresses but prefer EUI-64 addresses";
          in
          ''
            # override to ${msg} for ${i.name}
            ACTION=="add", SUBSYSTEM=="net", RUN+="${pkgs.procps}/bin/sysctl net.ipv6.conf.${replaceChars ["."] ["/"] i.name}.use_tempaddr=${toString val}"
          '') (filter (i: i.tempAddress != "default") interfaces);
      })
    ] ++ lib.optional (cfg.wlanInterfaces != {})
      (pkgs.writeTextFile {
        name = "99-zzz-40-wlanInterfaces.rules";
        destination = "/etc/udev/rules.d/99-zzz-40-wlanInterfaces.rules";
        text =
          let
            # Collect all interfaces that are defined for a device
            # as device:interface key:value pairs.
            wlanDeviceInterfaces =
              let
                allDevices = unique (mapAttrsToList (_: v: v.device) cfg.wlanInterfaces);
                interfacesOfDevice = d: filterAttrs (_: v: v.device == d) cfg.wlanInterfaces;
              in
                genAttrs allDevices (d: interfacesOfDevice d);

            # Convert device:interface key:value pairs into a list, and if it exists,
            # place the interface which is named after the device at the beginning.
            wlanListDeviceFirst = device: interfaces:
              if hasAttr device interfaces
              then mapAttrsToList (n: v: v//{_iName=n;}) (filterAttrs (n: _: n==device) interfaces) ++ mapAttrsToList (n: v: v//{_iName=n;}) (filterAttrs (n: _: n!=device) interfaces)
              else mapAttrsToList (n: v: v // {_iName = n;}) interfaces;

            # Udev script to execute for the default WLAN interface with the persistend udev name.
            # The script creates the required, new WLAN interfaces interfaces and configures the
            # existing, default interface.
            curInterfaceScript = device: current: new: pkgs.writeScript "udev-run-script-wlan-interfaces-${device}.sh" ''
              #!${pkgs.runtimeShell}
              # Change the wireless phy device to a predictable name.
              ${pkgs.iw}/bin/iw phy `${pkgs.coreutils}/bin/cat /sys/class/net/$INTERFACE/phy80211/name` set name ${device}

              # Add new WLAN interfaces
              ${flip concatMapStrings new (i: ''
              ${pkgs.iw}/bin/iw phy ${device} interface add ${i._iName} type managed
              '')}

              # Configure the current interface
              ${pkgs.iw}/bin/iw dev ${device} set type ${current.type}
              ${optionalString (current.type == "mesh" && current.meshID!=null) "${pkgs.iw}/bin/iw dev ${device} set meshid ${current.meshID}"}
              ${optionalString (current.type == "monitor" && current.flags!=null) "${pkgs.iw}/bin/iw dev ${device} set monitor ${current.flags}"}
              ${optionalString (current.type == "managed" && current.fourAddr!=null) "${pkgs.iw}/bin/iw dev ${device} set 4addr ${if current.fourAddr then "on" else "off"}"}
              ${optionalString (current.mac != null) "${pkgs.iproute}/bin/ip link set dev ${device} address ${current.mac}"}
            '';

            # Udev script to execute for a new WLAN interface. The script configures the new WLAN interface.
            newInterfaceScript = device: new: pkgs.writeScript "udev-run-script-wlan-interfaces-${new._iName}.sh" ''
              #!${pkgs.runtimeShell}
              # Configure the new interface
              ${pkgs.iw}/bin/iw dev ${new._iName} set type ${new.type}
              ${optionalString (new.type == "mesh" && new.meshID!=null) "${pkgs.iw}/bin/iw dev ${device} set meshid ${new.meshID}"}
              ${optionalString (new.type == "monitor" && new.flags!=null) "${pkgs.iw}/bin/iw dev ${device} set monitor ${new.flags}"}
              ${optionalString (new.type == "managed" && new.fourAddr!=null) "${pkgs.iw}/bin/iw dev ${device} set 4addr ${if new.fourAddr then "on" else "off"}"}
              ${optionalString (new.mac != null) "${pkgs.iproute}/bin/ip link set dev ${device} address ${new.mac}"}
            '';

            # Udev attributes for systemd to name the device and to create a .device target.
            systemdAttrs = n: ''NAME:="${n}", ENV{INTERFACE}:="${n}", ENV{SYSTEMD_ALIAS}:="/sys/subsystem/net/devices/${n}", TAG+="systemd"'';
          in
          flip (concatMapStringsSep "\n") (attrNames wlanDeviceInterfaces) (device:
            let
              interfaces = wlanListDeviceFirst device wlanDeviceInterfaces.${device};
              curInterface = elemAt interfaces 0;
              newInterfaces = drop 1 interfaces;
            in ''
            # It is important to have that rule first as overwriting the NAME attribute also prevents the
            # next rules from matching.
            ${flip (concatMapStringsSep "\n") (wlanListDeviceFirst device wlanDeviceInterfaces.${device}) (interface:
            ''ACTION=="add", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", ENV{INTERFACE}=="${interface._iName}", ${systemdAttrs interface._iName}, RUN+="${newInterfaceScript device interface}"'')}

            # Add the required, new WLAN interfaces to the default WLAN interface with the
            # persistent, default name as assigned by udev.
            ACTION=="add", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", NAME=="${device}", ${systemdAttrs curInterface._iName}, RUN+="${curInterfaceScript device curInterface newInterfaces}"
            # Generate the same systemd events for both 'add' and 'move' udev events.
            ACTION=="move", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", NAME=="${device}", ${systemdAttrs curInterface._iName}
          '');
      });
  };

}
