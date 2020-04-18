{ config, lib, pkgs, ... }:

with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let

  cfg = config.systemd.network;

  checkLink = checkUnitConfig "Link" [
    (assertOnlyFields [
      "Description" "Alias" "MACAddressPolicy" "MACAddress" "NamePolicy" "Name" "OriginalName"
      "MTUBytes" "BitsPerSecond" "Duplex" "AutoNegotiation" "WakeOnLan" "Port" "Advertise"
      "TCPSegmentationOffload" "TCP6SegmentationOffload" "GenericSegmentationOffload"
      "GenericReceiveOffload" "LargeReceiveOffload" "RxChannels" "TxChannels"
      "OtherChannels" "CombinedChannels"
    ])
    (assertValueOneOf "MACAddressPolicy" ["persistent" "random" "none"])
    (assertMacAddress "MACAddress")
    (assertByteFormat "MTUBytes")
    (assertByteFormat "BitsPerSecond")
    (assertValueOneOf "Duplex" ["half" "full"])
    (assertValueOneOf "AutoNegotiation" boolValues)
    (assertValueOneOf "WakeOnLan" ["phy" "unicast" "multicast" "broadcast" "arp" "magic" "secureon" "off"])
    (assertValueOneOf "Port" ["tp" "aui" "bnc" "mii" "fibre"])
    (assertValueOneOf "TCPSegmentationOffload" boolValues)
    (assertValueOneOf "TCP6SegmentationOffload" boolValues)
    (assertValueOneOf "GenericSegmentationOffload" boolValues)
    (assertValueOneOf "UDPSegmentationOffload" boolValues)
    (assertValueOneOf "GenericReceiveOffload" boolValues)
    (assertValueOneOf "LargeReceiveOffload" boolValues)
    (assertInt "RxChannels")
    (assertMinimum "RxChannels" 1)
    (assertInt "TxChannels")
    (assertMinimum "TxChannels" 1)
    (assertInt "OtherChannels")
    (assertMinimum "OtherChannels" 1)
    (assertInt "CombinedChannels")
    (assertMinimum "CombinedChannels" 1)
  ];

  checkNetdev = checkUnitConfig "Netdev" [
    (assertOnlyFields [
      "Description" "Name" "Kind" "MTUBytes" "MACAddress"
    ])
    (assertHasField "Name")
    (assertHasField "Kind")
    (assertValueOneOf "Kind" [
      "bond" "bridge" "dummy" "gre" "gretap" "ip6gre" "ip6tnl" "ip6gretap" "ipip"
      "ipvlan" "macvlan" "macvtap" "sit" "tap" "tun" "veth" "vlan" "vti" "vti6"
      "vxlan" "geneve" "vrf" "vcan" "vxcan" "wireguard" "netdevsim" "xfrm"
    ])
    (assertByteFormat "MTUBytes")
    (assertMacAddress "MACAddress")
  ];

  checkVRF = checkUnitConfig "VRF" [
    (assertOnlyFields [ "Table" ])
    (assertMinimum "Table" 0)
  ];

  # NOTE The PrivateKey directive is missing on purpose here, please
  # do not add it to this list. The nix store is world-readable let's
  # refrain ourselves from providing a footgun.
  checkWireGuard = checkUnitConfig "WireGuard" [
    (assertOnlyFields [
      "PrivateKeyFile" "ListenPort" "FwMark"
    ])
    # The following check won't work on nix <= 2.2
    # see https://github.com/NixOS/nix/pull/2378
    #
    # Add this again when we'll have drop the
    # nix < 2.2 support.
    # (assertRange "FwMark" 1 4294967295)
  ];

  # NOTE The PresharedKey directive is missing on purpose here, please
  # do not add it to this list. The nix store is world-readable,let's
  # refrain ourselves from providing a footgun.
  checkWireGuardPeer = checkUnitConfig "WireGuardPeer" [
    (assertOnlyFields [
      "PublicKey" "PresharedKeyFile" "AllowedIPs"
      "Endpoint" "PersistentKeepalive"
    ])
    (assertRange "PersistentKeepalive" 1 65535)
  ];

  checkVlan = checkUnitConfig "VLAN" [
    (assertOnlyFields ["Id" "GVRP" "MVRP" "LooseBinding" "ReorderHeader"])
    (assertRange "Id" 0 4094)
    (assertValueOneOf "GVRP" boolValues)
    (assertValueOneOf "MVRP" boolValues)
    (assertValueOneOf "LooseBinding" boolValues)
    (assertValueOneOf "ReorderHeader" boolValues)
  ];

  checkMacvlan = checkUnitConfig "MACVLAN" [
    (assertOnlyFields ["Mode"])
    (assertValueOneOf "Mode" ["private" "vepa" "bridge" "passthru"])
  ];

  checkVxlan = checkUnitConfig "VXLAN" [
    (assertOnlyFields [
      "Id" "Remote" "Local" "TOS" "TTL" "MacLearning" "FDBAgeingSec"
      "MaximumFDBEntries" "ReduceARPProxy" "L2MissNotification"
      "L3MissNotification" "RouteShortCircuit" "UDPChecksum"
      "UDP6ZeroChecksumTx" "UDP6ZeroChecksumRx" "RemoteChecksumTx"
      "RemoteChecksumRx" "GroupPolicyExtension" "DestinationPort" "PortRange"
      "FlowLabel"
    ])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "MacLearning" boolValues)
    (assertValueOneOf "ReduceARPProxy" boolValues)
    (assertValueOneOf "L2MissNotification" boolValues)
    (assertValueOneOf "L3MissNotification" boolValues)
    (assertValueOneOf "RouteShortCircuit" boolValues)
    (assertValueOneOf "UDPChecksum" boolValues)
    (assertValueOneOf "UDP6ZeroChecksumTx" boolValues)
    (assertValueOneOf "UDP6ZeroChecksumRx" boolValues)
    (assertValueOneOf "RemoteChecksumTx" boolValues)
    (assertValueOneOf "RemoteChecksumRx" boolValues)
    (assertValueOneOf "GroupPolicyExtension" boolValues)
    (assertRange "FlowLabel" 0 1048575)
  ];

  checkTunnel = checkUnitConfig "Tunnel" [
    (assertOnlyFields [
      "Local" "Remote" "TOS" "TTL" "DiscoverPathMTU" "IPv6FlowLabel" "CopyDSCP"
      "EncapsulationLimit" "Key" "InputKey" "OutputKey" "Mode" "Independent"
      "AllowLocalRemote"
    ])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "DiscoverPathMTU" boolValues)
    (assertValueOneOf "CopyDSCP" boolValues)
    (assertValueOneOf "Mode" ["ip6ip6" "ipip6" "any"])
    (assertValueOneOf "Independent" boolValues)
    (assertValueOneOf "AllowLocalRemote" boolValues)
  ];

  checkPeer = checkUnitConfig "Peer" [
    (assertOnlyFields ["Name" "MACAddress"])
    (assertMacAddress "MACAddress")
  ];

  tunTapChecks = [
    (assertOnlyFields ["OneQueue" "MultiQueue" "PacketInfo" "VNetHeader" "User" "Group"])
    (assertValueOneOf "OneQueue" boolValues)
    (assertValueOneOf "MultiQueue" boolValues)
    (assertValueOneOf "PacketInfo" boolValues)
    (assertValueOneOf "VNetHeader" boolValues)
  ];

  checkTun = checkUnitConfig "Tun" tunTapChecks;

  checkTap = checkUnitConfig "Tap" tunTapChecks;

  checkBond = checkUnitConfig "Bond" [
    (assertOnlyFields [
      "Mode" "TransmitHashPolicy" "LACPTransmitRate" "MIIMonitorSec"
      "UpDelaySec" "DownDelaySec" "LearnPacketIntervalSec" "AdSelect"
      "FailOverMACPolicy" "ARPValidate" "ARPIntervalSec" "ARPIPTargets"
      "ARPAllTargets" "PrimaryReselectPolicy" "ResendIGMP" "PacketsPerSlave"
      "GratuitousARP" "AllSlavesActive" "MinLinks"
    ])
    (assertValueOneOf "Mode" [
      "balance-rr" "active-backup" "balance-xor"
      "broadcast" "802.3ad" "balance-tlb" "balance-alb"
    ])
    (assertValueOneOf "TransmitHashPolicy" [
      "layer2" "layer3+4" "layer2+3" "encap2+3" "encap3+4"
    ])
    (assertValueOneOf "LACPTransmitRate" ["slow" "fast"])
    (assertValueOneOf "AdSelect" ["stable" "bandwidth" "count"])
    (assertValueOneOf "FailOverMACPolicy" ["none" "active" "follow"])
    (assertValueOneOf "ARPValidate" ["none" "active" "backup" "all"])
    (assertValueOneOf "ARPAllTargets" ["any" "all"])
    (assertValueOneOf "PrimaryReselectPolicy" ["always" "better" "failure"])
    (assertRange "ResendIGMP" 0 255)
    (assertRange "PacketsPerSlave" 0 65535)
    (assertRange "GratuitousARP" 0 255)
    (assertValueOneOf "AllSlavesActive" boolValues)
  ];

  checkXfrm = checkUnitConfig "Xfrm" [
    (assertOnlyFields [
      "InterfaceId" "Independent"
    ])
    # The following check won't work on nix <= 2.2
    # see https://github.com/NixOS/nix/pull/2378
    #
    # Add this again when we'll have drop the
    # nix < 2.2 support.
    # (assertRange "InterfaceId" 1 4294967295)
    (assertValueOneOf "Independent" boolValues)
  ];

  checkNetwork = checkUnitConfig "Network" [
    (assertOnlyFields [
      "Description" "DHCP" "DHCPServer" "LinkLocalAddressing" "IPv4LLRoute"
      "IPv6Token" "LLMNR" "MulticastDNS" "DNSOverTLS" "DNSSEC"
      "DNSSECNegativeTrustAnchors" "LLDP" "EmitLLDP" "BindCarrier" "Address"
      "Gateway" "DNS" "Domains" "NTP" "IPForward" "IPMasquerade"
      "IPv6PrivacyExtensions" "IPv6AcceptRA" "IPv6DuplicateAddressDetection"
      "IPv6HopLimit" "IPv4ProxyARP" "IPv6ProxyNDP" "IPv6ProxyNDPAddress"
      "IPv6PrefixDelegation" "IPv6MTUBytes" "Bridge" "Bond" "VRF" "VLAN"
      "IPVLAN" "MACVLAN" "VXLAN" "Tunnel" "ActiveSlave" "PrimarySlave"
      "ConfigureWithoutCarrier" "Xfrm"
    ])
    # Note: For DHCP the values both, none, v4, v6 are deprecated
    (assertValueOneOf "DHCP" ["yes" "no" "ipv4" "ipv6" "both" "none" "v4" "v6"])
    (assertValueOneOf "DHCPServer" boolValues)
    (assertValueOneOf "LinkLocalAddressing" ["yes" "no" "ipv4" "ipv6" "ipv4-fallback" "fallback"])
    (assertValueOneOf "IPv4LLRoute" boolValues)
    (assertValueOneOf "LLMNR" ["yes" "resolve" "no"])
    (assertValueOneOf "MulticastDNS" ["yes" "resolve" "no"])
    (assertValueOneOf "DNSOverTLS" ["opportunistic" "no"])
    (assertValueOneOf "DNSSEC" ["yes" "allow-downgrade" "no"])
    (assertValueOneOf "LLDP" ["yes" "routers-only" "no"])
    (assertValueOneOf "EmitLLDP" ["yes" "no" "nearest-bridge" "non-tpmr-bridge" "customer-bridge"])
    (assertValueOneOf "IPForward" ["yes" "no" "ipv4" "ipv6"])
    (assertValueOneOf "IPMasquerade" boolValues)
    (assertValueOneOf "IPv6PrivacyExtensions" ["yes" "no" "prefer-public" "kernel"])
    (assertValueOneOf "IPv6AcceptRA" boolValues)
    (assertValueOneOf "IPv4ProxyARP" boolValues)
    (assertValueOneOf "IPv6ProxyNDP" boolValues)
    (assertValueOneOf "IPv6PrefixDelegation" (boolValues ++ [ "dhcpv6" "static" ]))
    (assertValueOneOf "ActiveSlave" boolValues)
    (assertValueOneOf "PrimarySlave" boolValues)
    (assertValueOneOf "ConfigureWithoutCarrier" boolValues)
  ];

  checkAddress = checkUnitConfig "Address" [
    (assertOnlyFields [
      "Address" "Peer" "Broadcast" "Label" "PreferredLifetime" "Scope"
      "HomeAddress" "DuplicateAddressDetection" "ManageTemporaryAddress"
      "PrefixRoute" "AutoJoin"
    ])
    (assertHasField "Address")
    (assertValueOneOf "PreferredLifetime" ["forever" "infinity" "0" 0])
    (assertValueOneOf "HomeAddress" boolValues)
    (assertValueOneOf "DuplicateAddressDetection" boolValues)
    (assertValueOneOf "ManageTemporaryAddress" boolValues)
    (assertValueOneOf "PrefixRoute" boolValues)
    (assertValueOneOf "AutoJoin" boolValues)
  ];

  checkRoutingPolicyRule = checkUnitConfig "RoutingPolicyRule" [
    (assertOnlyFields [
      "TypeOfService" "From" "To" "FirewallMark" "Table" "Priority"
      "IncomingInterface" "OutgoingInterface" "SourcePort" "DestinationPort"
      "IPProtocol" "InvertRule" "Family"
    ])
    (assertRange "TypeOfService" 0 255)
    # The following check won't work on nix <= 2.2
    # see https://github.com/NixOS/nix/pull/2378
    #
    # Add this again when we'll have drop the
    # nix < 2.2 support.
    #  (assertRange "FirewallMark" 1 4294967295)
    (assertInt "Priority")
    (assertPort "SourcePort")
    (assertPort "DestinationPort")
    (assertValueOneOf "InvertRule" boolValues)
    (assertValueOneOf "Family" ["ipv4" "ipv6" "both"])
  ];

  checkRoute = checkUnitConfig "Route" [
    (assertOnlyFields [
      "Gateway" "GatewayOnLink" "Destination" "Source" "Metric"
      "IPv6Preference" "Scope" "PreferredSource" "Table" "Protocol" "Type"
      "InitialCongestionWindow" "InitialAdvertisedReceiveWindow" "QuickAck"
      "MTUBytes"
    ])
  ];

  checkDhcp = checkUnitConfig "DHCP" [
    (assertOnlyFields [
      "UseDNS" "UseNTP" "UseMTU" "Anonymize" "SendHostname" "UseHostname"
      "Hostname" "UseDomains" "UseRoutes" "UseTimezone" "CriticalConnection"
      "ClientIdentifier" "VendorClassIdentifier" "UserClass" "DUIDType"
      "DUIDRawData" "IAID" "RequestBroadcast" "RouteMetric" "RouteTable"
      "ListenPort" "RapidCommit"
    ])
    (assertValueOneOf "UseDNS" boolValues)
    (assertValueOneOf "UseNTP" boolValues)
    (assertValueOneOf "UseMTU" boolValues)
    (assertValueOneOf "Anonymize" boolValues)
    (assertValueOneOf "SendHostname" boolValues)
    (assertValueOneOf "UseHostname" boolValues)
    (assertValueOneOf "UseDomains" ["yes" "no" "route"])
    (assertValueOneOf "UseRoutes" boolValues)
    (assertValueOneOf "UseTimezone" boolValues)
    (assertValueOneOf "CriticalConnection" boolValues)
    (assertValueOneOf "RequestBroadcast" boolValues)
    (assertInt "RouteTable")
    (assertMinimum "RouteTable" 0)
    (assertValueOneOf "RapidCommit" boolValues)
  ];

  checkDhcpServer = checkUnitConfig "DHCPServer" [
    (assertOnlyFields [
      "PoolOffset" "PoolSize" "DefaultLeaseTimeSec" "MaxLeaseTimeSec"
      "EmitDNS" "DNS" "EmitNTP" "NTP" "EmitRouter" "EmitTimezone" "Timezone"
    ])
    (assertValueOneOf "EmitDNS" boolValues)
    (assertValueOneOf "EmitNTP" boolValues)
    (assertValueOneOf "EmitRouter" boolValues)
    (assertValueOneOf "EmitTimezone" boolValues)
  ];

  # .network files have a [Link] section with different options than in .netlink files
  checkNetworkLink = checkUnitConfig "Link" [
    (assertOnlyFields [
      "MACAddress" "MTUBytes" "ARP" "Multicast" "Unmanaged" "RequiredForOnline"
    ])
    (assertMacAddress "MACAddress")
    (assertByteFormat "MTUBytes")
    (assertValueOneOf "ARP" boolValues)
    (assertValueOneOf "Multicast" boolValues)
    (assertValueOneOf "Unmanaged" boolValues)
    (assertValueOneOf "RequiredForOnline" (boolValues ++ ["off" "no-carrier" "dormant" "degraded-carrier" "carrier" "degraded" "enslaved" "routable"]))
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
    # overwrite enable option from above
    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable this .link unit. It's handled by udev no matter if <command>systemd-networkd</command> is enabled or not
      '';
    };

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

    vrfConfig = mkOption {
      default = {};
      example = { Table = 2342; };
      type = types.addCheck (types.attrsOf unitOption) checkVRF;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[VRF]</literal> section of the unit. See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
        A detailed explanation about how VRFs work can be found in the
        <link xlink:href="https://www.kernel.org/doc/Documentation/networking/vrf.txt">kernel
        docs</link>.
      '';
    };

    wireguardConfig = mkOption {
      default = {};
      example = {
        PrivateKeyFile = "/etc/wireguard/secret.key";
        ListenPort = 51820;
        FwMark = 42;
      };
      type = types.addCheck (types.attrsOf unitOption) checkWireGuard;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[WireGuard]</literal> section of the unit. See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
        Use <literal>PrivateKeyFile</literal> instead of
        <literal>PrivateKey</literal>: the nix store is
        world-readable.
      '';
    };

    wireguardPeers = mkOption {
      default = [];
      example = [ { wireguardPeerConfig={
        Endpoint = "192.168.1.1:51820";
        PublicKey = "27s0OvaBBdHoJYkH9osZpjpgSOVNw+RaKfboT/Sfq0g=";
        PresharedKeyFile = "/etc/wireguard/psk.key";
        AllowedIPs = [ "10.0.0.1/32" ];
        PersistentKeepalive = 15;
      };}];
      type = with types; listOf (submodule wireguardPeerOptions);
      description = ''
        Each item in this array specifies an option in the
        <literal>[WireGuardPeer]</literal> section of the unit. See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
        Use <literal>PresharedKeyFile</literal> instead of
        <literal>PresharedKey</literal>: the nix store is
        world-readable.
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

    xfrmConfig = mkOption {
      default = {};
      example = { InterfaceId = 1; };
      type = types.addCheck (types.attrsOf unitOption) checkXfrm;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Xfrm]</literal> section of the unit.  See
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

  routingPolicyRulesOptions = {
    options = {
      routingPolicyRuleConfig = mkOption {
        default = { };
        example = { routingPolicyRuleConfig = { Table = 10; IncomingInterface = "eth1"; Family = "both"; } ;};
        type = types.addCheck (types.attrsOf unitOption) checkRoutingPolicyRule;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[RoutingPolicyRule]</literal> section of the unit.  See
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

  wireguardPeerOptions = {
    options = {
      wireguardPeerConfig = mkOption {
        default = {};
        example = { };
        type = types.addCheck (types.attrsOf unitOption) checkWireGuardPeer;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[WireGuardPeer]</literal> section of the unit.  See
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

    bridge = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of bridge interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    bond = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of bond interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vrf = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vrf interfaces to be added to the network section of the
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

    xfrm = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of xfrm interfaces to be added to the network section of the
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

    routingPolicyRules = mkOption {
      default = [ ];
      type = with types; listOf (submodule routingPolicyRulesOptions);
      description = ''
        A list of routing policy rules sections to be added to the unit.  See
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

  networkConfig = { config, ... }: {
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

  commonMatchText = def: optionalString (def.matchConfig != {}) ''
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
          ${optionalString (def.xfrmConfig != { }) ''
            [Xfrm]
            ${attrsToSection def.xfrmConfig}

          ''}
          ${optionalString (def.vrfConfig != { }) ''
            [VRF]
            ${attrsToSection def.vrfConfig}

          ''}
          ${optionalString (def.wireguardConfig != { }) ''
            [WireGuard]
            ${attrsToSection def.wireguardConfig}

          ''}
          ${flip concatMapStrings def.wireguardPeers (x: ''
            [WireGuardPeer]
            ${attrsToSection x.wireguardPeerConfig}

          '')}
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
          ${concatStringsSep "\n" (map (s: "Bridge=${s}") def.bridge)}
          ${concatStringsSep "\n" (map (s: "Bond=${s}") def.bond)}
          ${concatStringsSep "\n" (map (s: "VRF=${s}") def.vrf)}
          ${concatStringsSep "\n" (map (s: "VLAN=${s}") def.vlan)}
          ${concatStringsSep "\n" (map (s: "MACVLAN=${s}") def.macvlan)}
          ${concatStringsSep "\n" (map (s: "VXLAN=${s}") def.vxlan)}
          ${concatStringsSep "\n" (map (s: "Tunnel=${s}") def.tunnel)}
          ${concatStringsSep "\n" (map (s: "Xfrm=${s}") def.xfrm)}

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
          ${flip concatMapStrings def.routingPolicyRules (x: ''
            [RoutingPolicyRule]
            ${attrsToSection x.routingPolicyRuleConfig}

          '')}
          ${def.extraConfig}
        '';
    };

  unitFiles = listToAttrs (map (name: {
    name = "systemd/network/${name}";
    value.source = "${cfg.units.${name}.unit}/${name}";
  }) (attrNames cfg.units));
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
      internal = true;
      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = mapAttrs (_: x: x // { internal = true; }) concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        }));
    };

  };

  config = mkMerge [
    # .link units are honored by udev, no matter if systemd-networkd is enabled or not.
    {
      systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.link" (linkToUnit n v)) cfg.links;
      environment.etc = unitFiles;
    }

    (mkIf config.systemd.network.enable {

      users.users.systemd-network.group = "systemd-network";

      systemd.additionalUpstreamSystemUnits = [
        "systemd-networkd.service" "systemd-networkd-wait-online.service"
      ];

      systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.netdev" (netdevToUnit n v)) cfg.netdevs
        // mapAttrs' (n: v: nameValuePair "${n}.network" (networkToUnit n v)) cfg.networks;

      systemd.services.systemd-networkd = {
        wantedBy = [ "multi-user.target" ];
        restartTriggers = attrNames unitFiles;
        # prevent race condition with interface renaming (#39069)
        requires = [ "systemd-udev-settle.service" ];
        after = [ "systemd-udev-settle.service" ];
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
    })
  ];
}
