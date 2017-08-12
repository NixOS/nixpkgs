{ config, lib, pkgs, ... }:

with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let

  cfg = config.systemd.network;

  checkLink = checkUnitConfig "Link" [
    (assertOnlyFields [
      "Description" "Alias" "MACAddressPolicy" "MACAddress" "NamePolicy" "Name"
      "MTUBytes" "BitsPerSecond" "Duplex" "WakeOnLan"
    ])
    (assertValueOneOf "MACAddressPolicy" ["persistent" "random"])
    (assertMacAddress "MACAddress")
    (assertValueOneOf "NamePolicy" [
      "kernel" "database" "onboard" "slot" "path" "mac"
    ])
    (assertByteFormat "MTUBytes")
    (assertByteFormat "BitsPerSecond")
    (assertValueOneOf "Duplex" ["half" "full"])
    (assertValueOneOf "WakeOnLan" ["phy" "magic" "off"])
  ];

  checkNetdev = checkUnitConfig "Netdev" [
    (assertOnlyFields [
      "Description" "Name" "Kind" "MTUBytes" "MACAddress"
    ])
    (assertHasField "Name")
    (assertHasField "Kind")
    (assertValueOneOf "Kind" [
      "bridge" "bond" "vlan" "macvlan" "vxlan" "ipip"
      "gre" "sit" "vti" "veth" "tun" "tap" "dummy"
    ])
    (assertByteFormat "MTUBytes")
    (assertMacAddress "MACAddress")
  ];

  checkVlan = checkUnitConfig "VLAN" [
    (assertOnlyFields ["Id"])
    (assertRange "Id" 0 4094)
  ];

  checkMacvlan = checkUnitConfig "MACVLAN" [
    (assertOnlyFields ["Mode"])
    (assertValueOneOf "Mode" ["private" "vepa" "bridge" "passthru"])
  ];

  checkVxlan = checkUnitConfig "VXLAN" [
    (assertOnlyFields ["Id" "Group" "TOS" "TTL" "MacLearning"])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "MacLearning" boolValues)
  ];

  checkTunnel = checkUnitConfig "Tunnel" [
    (assertOnlyFields ["Local" "Remote" "TOS" "TTL" "DiscoverPathMTU"])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "DiscoverPathMTU" boolValues)
  ];

  checkPeer = checkUnitConfig "Peer" [
    (assertOnlyFields ["Name" "MACAddress"])
    (assertMacAddress "MACAddress")
  ];

  tunTapChecks = [
    (assertOnlyFields ["OneQueue" "MultiQueue" "PacketInfo" "User" "Group"])
    (assertValueOneOf "OneQueue" boolValues)
    (assertValueOneOf "MultiQueue" boolValues)
    (assertValueOneOf "PacketInfo" boolValues)
  ];

  checkTun = checkUnitConfig "Tun" tunTapChecks;

  checkTap = checkUnitConfig "Tap" tunTapChecks;

  checkBond = checkUnitConfig "Bond" [
    (assertOnlyFields [
      "Mode" "TransmitHashPolicy" "LACPTransmitRate" "MIIMonitorSec"
      "UpDelaySec" "DownDelaySec" "GratuitousARP"
    ])
    (assertValueOneOf "Mode" [
      "balance-rr" "active-backup" "balance-xor"
      "broadcast" "802.3ad" "balance-tlb" "balance-alb"
    ])
    (assertValueOneOf "TransmitHashPolicy" [
      "layer2" "layer3+4" "layer2+3" "encap2+3" "802.3ad" "encap3+4"
    ])
    (assertValueOneOf "LACPTransmitRate" ["slow" "fast"])
  ];

  checkNetwork = checkUnitConfig "Network" [
    (assertOnlyFields [
      "Description" "DHCP" "DHCPServer" "IPForward" "IPMasquerade" "IPv4LL" "IPv4LLRoute"
      "LLMNR" "MulticastDNS" "Domains" "Bridge" "Bond"
    ])
    (assertValueOneOf "DHCP" ["both" "none" "v4" "v6"])
    (assertValueOneOf "DHCPServer" boolValues)
    (assertValueOneOf "IPForward" ["yes" "no" "ipv4" "ipv6"])
    (assertValueOneOf "IPMasquerade" boolValues)
    (assertValueOneOf "IPv4LL" boolValues)
    (assertValueOneOf "IPv4LLRoute" boolValues)
    (assertValueOneOf "LLMNR" boolValues)
    (assertValueOneOf "MulticastDNS" boolValues)
  ];

  checkAddress = checkUnitConfig "Address" [
    (assertOnlyFields ["Address" "Peer" "Broadcast" "Label"])
    (assertHasField "Address")
  ];

  checkRoute = checkUnitConfig "Route" [
    (assertOnlyFields ["Gateway" "Destination" "Metric"])
    (assertHasField "Gateway")
  ];

  checkDhcp = checkUnitConfig "DHCP" [
    (assertOnlyFields [
      "UseDNS" "UseMTU" "SendHostname" "UseHostname" "UseDomains" "UseRoutes"
      "CriticalConnections" "VendorClassIdentifier" "RequestBroadcast"
      "RouteMetric"
    ])
    (assertValueOneOf "UseDNS" boolValues)
    (assertValueOneOf "UseMTU" boolValues)
    (assertValueOneOf "SendHostname" boolValues)
    (assertValueOneOf "UseHostname" boolValues)
    (assertValueOneOf "UseDomains" boolValues)
    (assertValueOneOf "UseRoutes" boolValues)
    (assertValueOneOf "CriticalConnections" boolValues)
    (assertValueOneOf "RequestBroadcast" boolValues)
  ];

  checkDhcpServer = checkUnitConfig "DHCPServer" [
    (assertOnlyFields [
      "PoolOffset" "PoolSize" "DefaultLeaseTimeSec" "MaxLeaseTimeSec"
      "EmitDNS" "DNS" "EmitNTP" "NTP" "EmitTimezone" "Timezone"
    ])
    (assertValueOneOf "EmitDNS" boolValues)
    (assertValueOneOf "EmitNTP" boolValues)
    (assertValueOneOf "EmitTimezone" boolValues)
  ];

  # .network files have a [Link] section with different options than in .netlink files
  checkNetworkLink = checkUnitConfig "Link" [
    (assertOnlyFields [
      "MACAddress" "MTUBytes" "ARP" "Unmanaged"
    ])
    (assertMacAddress "MACAddress")
    (assertByteFormat "MTUBytes")
    (assertValueOneOf "ARP" boolValues)
    (assertValueOneOf "Unmanaged" boolValues)
  ];


  commonNetworkOptions = {

    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to manage network configuration using <command>systemd-network</command>.
      '';
    };

    matchConfig = mkOption {
      default = {};
      example = { Name = "eth0"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Match]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.link</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        <citerefentry><refentrytitle>systemd.network</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        for details.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = "Extra configuration append to unit";
    };
  };

  linkOptions = commonNetworkOptions // {

    linkConfig = mkOption {
      default = {};
      example = { MACAddress = "00:ff:ee:aa:cc:dd"; };
      type = types.addCheck (types.attrsOf unitOption) checkLink;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Link]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.link</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  netdevOptions = commonNetworkOptions // {

    netdevConfig = mkOption {
      default = {};
      example = { Name = "mybridge"; Kind = "bridge"; };
      type = types.addCheck (types.attrsOf unitOption) checkNetdev;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Netdev]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vlanConfig = mkOption {
      default = {};
      example = { Id = "4"; };
      type = types.addCheck (types.attrsOf unitOption) checkVlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[VLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    macvlanConfig = mkOption {
      default = {};
      example = { Mode = "private"; };
      type = types.addCheck (types.attrsOf unitOption) checkMacvlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[MACVLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vxlanConfig = mkOption {
      default = {};
      example = { Id = "4"; };
      type = types.addCheck (types.attrsOf unitOption) checkVxlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[VXLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunnelConfig = mkOption {
      default = {};
      example = { Remote = "192.168.1.1"; };
      type = types.addCheck (types.attrsOf unitOption) checkTunnel;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tunnel]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    peerConfig = mkOption {
      default = {};
      example = { Name = "veth2"; };
      type = types.addCheck (types.attrsOf unitOption) checkPeer;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Peer]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) checkTun;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tun]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tapConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) checkTap;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tap]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    bondConfig = mkOption {
      default = {};
      example = { Mode = "802.3ad"; };
      type = types.addCheck (types.attrsOf unitOption) checkBond;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Bond]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  addressOptions = {
    options = {
      addressConfig = mkOption {
        default = {};
        example = { Address = "192.168.0.100/24"; };
        type = types.addCheck (types.attrsOf unitOption) checkAddress;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Address]</literal> section of the unit.  See
          <citerefentry><refentrytitle>systemd.network</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };
  };

  routeOptions = {
    options = {
      routeConfig = mkOption {
        default = {};
        example = { Gateway = "192.168.0.1"; };
        type = types.addCheck (types.attrsOf unitOption) checkRoute;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Route]</literal> section of the unit.  See
          <citerefentry><refentrytitle>systemd.network</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };
  };

  networkOptions = commonNetworkOptions // {

    networkConfig = mkOption {
      default = {};
      example = { Description = "My Network"; };
      type = types.addCheck (types.attrsOf unitOption) checkNetwork;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Network]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dhcpConfig = mkOption {
      default = {};
      example = { UseDNS = true; UseRoutes = true; };
      type = types.addCheck (types.attrsOf unitOption) checkDhcp;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCP]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dhcpServerConfig = mkOption {
      default = {};
      example = { PoolOffset = 50; EmitDNS = false; };
      type = types.addCheck (types.attrsOf unitOption) checkDhcpServer;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCPServer]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    linkConfig = mkOption {
      default = {};
      example = { Unmanaged = true; };
      type = types.addCheck (types.attrsOf unitOption) checkNetworkLink;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Link]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The name of the network interface to match against.
      '';
    };

    DHCP = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Whether to enable DHCP on the interfaces matched.
      '';
    };

    domains = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        A list of domains to pass to the network config.
      '';
    };

    address = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of addresses to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    gateway = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of gateways to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dns = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of dns servers to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    ntp = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of ntp servers to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    macvlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of macvlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vxlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vxlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunnel = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of tunnel interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    addresses = mkOption {
      default = [ ];
      type = with types; listOf (submodule addressOptions);
      description = ''
        A list of address sections to be added to the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    routes = mkOption {
      default = [ ];
      type = with types; listOf (submodule routeOptions);
      description = ''
        A list of route sections to be added to the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  networkConfig = { name, config, ... }: {
    config = {
      matchConfig = optionalAttrs (config.name != null) {
        Name = config.name;
      };
      networkConfig = optionalAttrs (config.DHCP != null) {
        DHCP = config.DHCP;
      } // optionalAttrs (config.domains != null) {
        Domains = concatStringsSep " " config.domains;
      };
    };
  };

  commonMatchText = def: ''
    [Match]
    ${attrsToSection def.matchConfig}
  '';

  linkToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def +
        ''
          [Link]
          ${attrsToSection def.linkConfig}

          ${def.extraConfig}
        '';
    };

  netdevToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def +
        ''
          [NetDev]
          ${attrsToSection def.netdevConfig}

          ${optionalString (def.vlanConfig != { }) ''
            [VLAN]
            ${attrsToSection def.vlanConfig}

          ''}
          ${optionalString (def.macvlanConfig != { }) ''
            [MACVLAN]
            ${attrsToSection def.macvlanConfig}

          ''}
          ${optionalString (def.vxlanConfig != { }) ''
            [VXLAN]
            ${attrsToSection def.vxlanConfig}

          ''}
          ${optionalString (def.tunnelConfig != { }) ''
            [Tunnel]
            ${attrsToSection def.tunnelConfig}

          ''}
          ${optionalString (def.peerConfig != { }) ''
            [Peer]
            ${attrsToSection def.peerConfig}

          ''}
          ${optionalString (def.tunConfig != { }) ''
            [Tun]
            ${attrsToSection def.tunConfig}

          ''}
          ${optionalString (def.tapConfig != { }) ''
            [Tap]
            ${attrsToSection def.tapConfig}

          ''}
          ${optionalString (def.bondConfig != { }) ''
            [Bond]
            ${attrsToSection def.bondConfig}

          ''}
          ${def.extraConfig}
        '';
    };

  networkToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def +
        ''
          ${optionalString (def.linkConfig != { }) ''
            [Link]
            ${attrsToSection def.linkConfig}

          ''}

          [Network]
          ${attrsToSection def.networkConfig}
          ${concatStringsSep "\n" (map (s: "Address=${s}") def.address)}
          ${concatStringsSep "\n" (map (s: "Gateway=${s}") def.gateway)}
          ${concatStringsSep "\n" (map (s: "DNS=${s}") def.dns)}
          ${concatStringsSep "\n" (map (s: "NTP=${s}") def.ntp)}
          ${concatStringsSep "\n" (map (s: "VLAN=${s}") def.vlan)}
          ${concatStringsSep "\n" (map (s: "MACVLAN=${s}") def.macvlan)}
          ${concatStringsSep "\n" (map (s: "VXLAN=${s}") def.vxlan)}
          ${concatStringsSep "\n" (map (s: "Tunnel=${s}") def.tunnel)}

          ${optionalString (def.dhcpConfig != { }) ''
            [DHCP]
            ${attrsToSection def.dhcpConfig}

          ''}
          ${optionalString (def.dhcpServerConfig != { }) ''
            [DHCPServer]
            ${attrsToSection def.dhcpServerConfig}

          ''}
          ${flip concatMapStrings def.addresses (x: ''
            [Address]
            ${attrsToSection x.addressConfig}

          '')}
          ${flip concatMapStrings def.routes (x: ''
            [Route]
            ${attrsToSection x.routeConfig}

          '')}
          ${def.extraConfig}
        '';
    };

  unitFiles = map (name: {
    target = "systemd/network/${name}";
    source = "${cfg.units.${name}.unit}/${name}";
  }) (attrNames cfg.units);
in

{

  options = {

    systemd.network.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable networkd or not.
      '';
    };

    systemd.network.links = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = linkOptions; } ]);
      description = "Definition of systemd network links.";
    };

    systemd.network.netdevs = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = netdevOptions; } ]);
      description = "Definition of systemd network devices.";
    };

    systemd.network.networks = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = networkOptions; } networkConfig ]);
      description = "Definition of systemd networks.";
    };

    systemd.network.units = mkOption {
      description = "Definition of networkd units.";
      default = {};
      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        }));
    };

  };

  config = mkIf config.systemd.network.enable {

    systemd.additionalUpstreamSystemUnits = [
      "systemd-networkd.service" "systemd-networkd-wait-online.service"
      "org.freedesktop.network1.busname"
    ];

    systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.link" (linkToUnit n v)) cfg.links
      // mapAttrs' (n: v: nameValuePair "${n}.netdev" (netdevToUnit n v)) cfg.netdevs
      // mapAttrs' (n: v: nameValuePair "${n}.network" (networkToUnit n v)) cfg.networks;

    environment.etc = unitFiles;

    systemd.services.systemd-networkd = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = map (f: f.source) (unitFiles);
    };

    systemd.services.systemd-networkd-wait-online = {
      wantedBy = [ "network-online.target" ];
    };

    systemd.services."systemd-network-wait-online@" = {
      description = "Wait for Network Interface %I to be Configured";
      conflicts = [ "shutdown.target" ];
      requisite = [ "systemd-networkd.service" ];
      after = [ "systemd-networkd.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online -i %I";
      };
    };

    services.resolved.enable = mkDefault true;
  };
}
