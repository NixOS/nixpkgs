{ config, lib, pkgs, utils, ... }:

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
    ++ concatMap (i: i.interfaces) (attrValues cfg.vswitches);

  slaveIfs = map (i: cfg.interfaces.${i}) (filter (i: cfg.interfaces ? ${i}) slaves);

  rstpBridges = flip filterAttrs cfg.bridges (_: { rstp, ... }: rstp);

  needsMstpd = rstpBridges != { };

  bridgeStp = optional needsMstpd (pkgs.writeTextFile {
    name = "bridge-stp";
    executable = true;
    destination = "/bin/bridge-stp";
    text = ''
      #!${pkgs.stdenv.shell} -e
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

  # udev script that configures a physical wlan device and adds virtual interfaces
  wlanDeviceUdevScript = device: interfaceList: pkgs.writeScript "wlan-${device}-udev-script" ''
    #!${pkgs.stdenv.shell}

    # Change the wireless phy device to a predictable name.
    if [ -e "/sys/class/net/${device}/phy80211/name" ]; then
      ${pkgs.iw}/bin/iw phy `${pkgs.coreutils}/bin/cat /sys/class/net/${device}/phy80211/name` set name ${device} || true
    fi

    # Crate new, virtual interfaces and configure them at the same time
    ${flip concatMapStrings (drop 1 interfaceList) (i: ''
    ${pkgs.iw}/bin/iw dev ${device} interface add ${i._iName} type ${i.type} \
      ${optionalString (i.type == "mesh" && i.meshID != null) "mesh_id ${i.meshID}"} \
      ${optionalString (i.type == "monitor" && i.flags != null) "flags ${i.flags}"} \
      ${optionalString (i.type == "managed" && i.fourAddr != null) "4addr ${if i.fourAddr then "on" else "off"}"} \
      ${optionalString (i.mac != null) "addr ${i.mac}"}
    '')}

    # Reconfigure and rename the default interface that already exists
    ${flip concatMapStrings (take 1 interfaceList) (i: ''
      ${pkgs.iw}/bin/iw dev ${device} set type ${i.type}
      ${optionalString (i.type == "mesh" && i.meshID != null) "${pkgs.iw}/bin/iw dev ${device} set meshid ${i.meshID}"}
      ${optionalString (i.type == "monitor" && i.flags != null) "${pkgs.iw}/bin/iw dev ${device} set monitor ${i.flags}"}
      ${optionalString (i.type == "managed" && i.fourAddr != null) "${pkgs.iw}/bin/iw dev ${device} set 4addr ${if i.fourAddr then "on" else "off"}"}
      ${optionalString (i.mac != null) "${pkgs.iproute}/bin/ip link set dev ${device} address ${i.mac}"}
      ${optionalString (device != i._iName) "${pkgs.iproute}/bin/ip link set dev ${device} name ${i._iName}"}
    '')}
  '';

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
        generate a random 32-bit ID using the following commands:

        <literal>cksum /etc/machine-id | while read c rest; do printf "%x" $c; done</literal>
        
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
      example = "131.211.84.1";
      type = types.nullOr types.str;
      description = ''
        The default gateway.  It can be left empty if it is auto-detected through DHCP.
      '';
    };

    networking.defaultGateway6 = mkOption {
      default = null;
      example = "2001:4d0:1e04:895::1";
      type = types.nullOr types.str;
      description = ''
        The default ipv6 gateway.  It can be left empty if it is auto-detected through DHCP.
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
      type = types.str;
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

    networking.vswitches = mkOption {
      default = { };
      example =
        { vs0.interfaces = [ "eth0" "eth1" ];
          vs1.interfaces = [ "eth2" "wlan0" ];
        };
      description =
        ''
          This option allows you to define Open vSwitches that connect
          physical networks together. The value of this option is an
          attribute set. Each attribute specifies a vswitch, with the
          attribute name specifying the name of the vswitch's network
          interface.
        '';

      type = types.attrsOf types.optionSet;

      options = {

        interfaces = mkOption {
          example = [ "eth0" "eth1" ];
          type = types.listOf types.str;
          description =
            "The physical network interfaces connected by the vSwitch.";
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
          type = types.listOf types.str;
          description =
            "The physical network interfaces connected by the bridge.";
        };

        rstp = mkOption {
          example = true;
          default = false;
          type = types.bool;
          description = "Whether the bridge interface should enable rstp.";
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
          type = types.str;
          description = "The interface the vlan will transmit packets through.";
        };

      };
    };

    networking.wlanInterfaces = mkOption {
      default = { };
      example = {
        "wlan-station0" = {
            device = "wlp6s0";
        };
        "wlan-adhoc0" = {
            type = "ibss";
            device = "wlp6s0";
            mac = "02:00:00:00:00:01";
        };
        "wlan-p2p0" = {
            device = "wlp6s0";
            mac = "02:00:00:00:00:02";
        };
        "wlan-ap0" = {
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

      type = types.attrsOf types.optionSet;

      options = {

        device = mkOption {
          type = types.string;
          example = "wlp6s0";
          description = "The name of the underlying hardware WLAN device as assigned by <literal>udev</literal>.";
        };

        type = mkOption {
          type = types.string;
          default = "managed";
          example = "ibss";
          description = ''
            The type of the WLAN interface. The type has to be either <literal>managed</literal>,
            <literal>ibss</literal>, <literal>monitor</literal>, <literal>mesh</literal> or <literal>wds</literal>.
            Also, the type has to be supported by the underlying hardware of the device.
          '';
        };

        meshID = mkOption {
          type = types.nullOr types.string;
          default = null;
          description = "MeshID of interface with type <literal>mesh</literal>.";
        };

        flags = mkOption {
          type = types.nullOr types.string;
          default = null;
          example = "control";
          description = ''
            Flags for interface of type <literal>monitor</literal>. The valid flags are:
            none:     no special flags
            fcsfail:  show frames with FCS errors
            control:  show control frames
            otherbss: show frames from other BSSes
            cook:     use cooked mode
            active:   use active mode (ACK incoming unicast packets)
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
      })) ++ (flip map slaveIfs (i: {
        assertion = i.ip4 == [ ] && i.ipAddress == null && i.ip6 == [ ] && i.ipv6Address == null;
        message = "The networking.interfaces.${i.name} must not have any defined ips when it is a slave.";
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
        pkgs.openresolv
      ]
      ++ optionals config.networking.wireless.enable [
        pkgs.wirelesstools # FIXME: obsolete?
        pkgs.iw
        pkgs.rfkill
      ]
      ++ bridgeStp;

    systemd.targets."network-interfaces" =
      { description = "All Network Interfaces";
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
    } // (listToAttrs (flip map interfaces (i:
      nameValuePair "network-link-${i.name}"
      { description = "Link configuration of ${i.name}";
        wantedBy = [ "network-interfaces.target" ];
        before = [ "network-interfaces.target" ];
        bindsTo = if config.boot.isContainer then [] else [ (subsystemDevice i.name) ];
        after = [ (subsystemDevice i.name) "network-pre.target" ];
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
          '';
      })));

    services.mstpd = mkIf needsMstpd { enable = true; };

    virtualisation.vswitch = mkIf (cfg.vswitches != { }) { enable = true; };

    services.udev.packages = mkIf (cfg.wlanInterfaces != {}) [
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
              #!${pkgs.stdenv.shell}
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
            newInterfaceScript = new: pkgs.writeScript "udev-run-script-wlan-interfaces-${new._iName}.sh" ''
              #!${pkgs.stdenv.shell}
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
              interfaces = wlanListDeviceFirst device wlanDeviceInterfaces."${device}";
              curInterface = elemAt interfaces 0;
              newInterfaces = drop 1 interfaces;
            in ''
            # It is important to have that rule first as overwriting the NAME attribute also prevents the
            # next rules from matching.
            ${flip (concatMapStringsSep "\n") (wlanListDeviceFirst device wlanDeviceInterfaces."${device}") (interface:
            ''ACTION=="add", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", ENV{INTERFACE}=="${interface._iName}", ${systemdAttrs interface._iName}, RUN+="${newInterfaceScript interface}"'')}

            # Add the required, new WLAN interfaces to the default WLAN interface with the
            # persistent, default name as assigned by udev.
            ACTION=="add", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", NAME=="${device}", ${systemdAttrs curInterface._iName}, RUN+="${curInterfaceScript device curInterface newInterfaces}"
            # Generate the same systemd events for both 'add' and 'move' udev events.
            ACTION=="move", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", NAME=="${device}", ${systemdAttrs curInterface._iName}
          '');
      }) ];

  };

}
