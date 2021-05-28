{ config, lib, pkgs, ... }:

with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let

  cfg = config.systemd.network;

  check = {

    link = {

      sectionLink = checkUnitConfig "Link" [
        (assertOnlyFields [
          "Description"
          "Alias"
          "MACAddressPolicy"
          "MACAddress"
          "NamePolicy"
          "Name"
          "AlternativeNamesPolicy"
          "AlternativeName"
          "MTUBytes"
          "BitsPerSecond"
          "Duplex"
          "AutoNegotiation"
          "WakeOnLan"
          "Port"
          "Advertise"
          "ReceiveChecksumOffload"
          "TransmitChecksumOffload"
          "TCPSegmentationOffload"
          "TCP6SegmentationOffload"
          "GenericSegmentationOffload"
          "GenericReceiveOffload"
          "LargeReceiveOffload"
          "RxChannels"
          "TxChannels"
          "OtherChannels"
          "CombinedChannels"
          "RxBufferSize"
          "TxBufferSize"
        ])
        (assertValueOneOf "MACAddressPolicy" ["persistent" "random" "none"])
        (assertMacAddress "MACAddress")
        (assertByteFormat "MTUBytes")
        (assertByteFormat "BitsPerSecond")
        (assertValueOneOf "Duplex" ["half" "full"])
        (assertValueOneOf "AutoNegotiation" boolValues)
        (assertValueOneOf "WakeOnLan" ["phy" "unicast" "multicast" "broadcast" "arp" "magic" "secureon" "off"])
        (assertValueOneOf "Port" ["tp" "aui" "bnc" "mii" "fibre"])
        (assertValueOneOf "ReceiveChecksumOffload" boolValues)
        (assertValueOneOf "TransmitChecksumOffload" boolValues)
        (assertValueOneOf "TCPSegmentationOffload" boolValues)
        (assertValueOneOf "TCP6SegmentationOffload" boolValues)
        (assertValueOneOf "GenericSegmentationOffload" boolValues)
        (assertValueOneOf "GenericReceiveOffload" boolValues)
        (assertValueOneOf "LargeReceiveOffload" boolValues)
        (assertInt "RxChannels")
        (assertRange "RxChannels" 1 4294967295)
        (assertInt "TxChannels")
        (assertRange "TxChannels" 1 4294967295)
        (assertInt "OtherChannels")
        (assertRange "OtherChannels" 1 4294967295)
        (assertInt "CombinedChannels")
        (assertRange "CombinedChannels" 1 4294967295)
        (assertInt "RxBufferSize")
        (assertInt "TxBufferSize")
      ];
    };

    netdev = let

      tunChecks = [
        (assertOnlyFields [
          "MultiQueue"
          "PacketInfo"
          "VNetHeader"
          "User"
          "Group"
        ])
        (assertValueOneOf "MultiQueue" boolValues)
        (assertValueOneOf "PacketInfo" boolValues)
        (assertValueOneOf "VNetHeader" boolValues)
      ];
    in {

      sectionNetdev = checkUnitConfig "Netdev" [
        (assertOnlyFields [
          "Description"
          "Name"
          "Kind"
          "MTUBytes"
          "MACAddress"
        ])
        (assertHasField "Name")
        (assertHasField "Kind")
        (assertValueOneOf "Kind" [
          "bond"
          "bridge"
          "dummy"
          "gre"
          "gretap"
          "erspan"
          "ip6gre"
          "ip6tnl"
          "ip6gretap"
          "ipip"
          "ipvlan"
          "macvlan"
          "macvtap"
          "sit"
          "tap"
          "tun"
          "veth"
          "vlan"
          "vti"
          "vti6"
          "vxlan"
          "geneve"
          "l2tp"
          "macsec"
          "vrf"
          "vcan"
          "vxcan"
          "wireguard"
          "netdevsim"
          "nlmon"
          "fou"
          "xfrm"
          "ifb"
        ])
        (assertByteFormat "MTUBytes")
        (assertMacAddress "MACAddress")
      ];

      sectionVLAN = checkUnitConfig "VLAN" [
        (assertOnlyFields [
          "Id"
          "GVRP"
          "MVRP"
          "LooseBinding"
          "ReorderHeader"
        ])
        (assertInt "Id")
        (assertRange "Id" 0 4094)
        (assertValueOneOf "GVRP" boolValues)
        (assertValueOneOf "MVRP" boolValues)
        (assertValueOneOf "LooseBinding" boolValues)
        (assertValueOneOf "ReorderHeader" boolValues)
      ];

      sectionMACVLAN = checkUnitConfig "MACVLAN" [
        (assertOnlyFields [
          "Mode"
        ])
        (assertValueOneOf "Mode" ["private" "vepa" "bridge" "passthru"])
      ];

      sectionVXLAN = checkUnitConfig "VXLAN" [
        (assertOnlyFields [
          "VNI"
          "Remote"
          "Local"
          "Group"
          "TOS"
          "TTL"
          "MacLearning"
          "FDBAgeingSec"
          "MaximumFDBEntries"
          "ReduceARPProxy"
          "L2MissNotification"
          "L3MissNotification"
          "RouteShortCircuit"
          "UDPChecksum"
          "UDP6ZeroChecksumTx"
          "UDP6ZeroChecksumRx"
          "RemoteChecksumTx"
          "RemoteChecksumRx"
          "GroupPolicyExtension"
          "GenericProtocolExtension"
          "DestinationPort"
          "PortRange"
          "FlowLabel"
          "IPDoNotFragment"
        ])
        (assertInt "VNI")
        (assertRange "VNI" 1 16777215)
        (assertValueOneOf "MacLearning" boolValues)
        (assertInt "MaximumFDBEntries")
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
        (assertValueOneOf "GenericProtocolExtension" boolValues)
        (assertInt "FlowLabel")
        (assertRange "FlowLabel" 0 1048575)
        (assertValueOneOf "IPDoNotFragment" (boolValues + ["inherit"]))
      ];

      sectionTunnel = checkUnitConfig "Tunnel" [
        (assertOnlyFields [
          "Local"
          "Remote"
          "TOS"
          "TTL"
          "DiscoverPathMTU"
          "IPv6FlowLabel"
          "CopyDSCP"
          "EncapsulationLimit"
          "Key"
          "InputKey"
          "OutputKey"
          "Mode"
          "Independent"
          "AssignToLoopback"
          "AllowLocalRemote"
          "FooOverUDP"
          "FOUDestinationPort"
          "FOUSourcePort"
          "Encapsulation"
          "IPv6RapidDeploymentPrefix"
          "ISATAP"
          "SerializeTunneledPackets"
          "ERSPANIndex"
        ])
        (assertInt "TTL")
        (assertRange "TTL" 0 255)
        (assertValueOneOf "DiscoverPathMTU" boolValues)
        (assertValueOneOf "CopyDSCP" boolValues)
        (assertValueOneOf "Mode" ["ip6ip6" "ipip6" "any"])
        (assertValueOneOf "Independent" boolValues)
        (assertValueOneOf "AssignToLoopback" boolValues)
        (assertValueOneOf "AllowLocalRemote" boolValues)
        (assertValueOneOf "FooOverUDP" boolValues)
        (assertPort "FOUDestinationPort")
        (assertPort "FOUSourcePort")
        (assertValueOneOf "Encapsulation" ["FooOverUDP" "GenericUDPEncapsulation"])
        (assertValueOneOf "ISATAP" boolValues)
        (assertValueOneOf "SerializeTunneledPackets" boolValues)
        (assertInt "ERSPANIndex")
        (assertRange "ERSPANIndex" 1 1048575)
      ];

      sectionPeer = checkUnitConfig "Peer" [
        (assertOnlyFields [
          "Name"
          "MACAddress"
        ])
        (assertMacAddress "MACAddress")
      ];

      sectionTun = checkUnitConfig "Tun" tunChecks;

      sectionTap = checkUnitConfig "Tap" tunChecks;

      # NOTE The PrivateKey directive is missing on purpose here, please
      # do not add it to this list. The nix store is world-readable let's
      # refrain ourselves from providing a footgun.
      sectionWireGuard = checkUnitConfig "WireGuard" [
        (assertOnlyFields [
          "PrivateKeyFile"
          "ListenPort"
          "FirewallMark"
        ])
        (assertInt "FirewallMark")
        (assertRange "FirewallMark" 1 4294967295)
      ];

      # NOTE The PresharedKey directive is missing on purpose here, please
      # do not add it to this list. The nix store is world-readable,let's
      # refrain ourselves from providing a footgun.
      sectionWireGuardPeer = checkUnitConfig "WireGuardPeer" [
        (assertOnlyFields [
          "PublicKey"
          "PresharedKeyFile"
          "AllowedIPs"
          "Endpoint"
          "PersistentKeepalive"
        ])
        (assertInt "PersistentKeepalive")
        (assertRange "PersistentKeepalive" 0 65535)
      ];

      sectionBond = checkUnitConfig "Bond" [
        (assertOnlyFields [
          "Mode"
          "TransmitHashPolicy"
          "LACPTransmitRate"
          "MIIMonitorSec"
          "UpDelaySec"
          "DownDelaySec"
          "LearnPacketIntervalSec"
          "AdSelect"
          "AdActorSystemPriority"
          "AdUserPortKey"
          "AdActorSystem"
          "FailOverMACPolicy"
          "ARPValidate"
          "ARPIntervalSec"
          "ARPIPTargets"
          "ARPAllTargets"
          "PrimaryReselectPolicy"
          "ResendIGMP"
          "PacketsPerSlave"
          "GratuitousARP"
          "AllSlavesActive"
          "DynamicTransmitLoadBalancing"
          "MinLinks"
        ])
        (assertValueOneOf "Mode" [
          "balance-rr"
          "active-backup"
          "balance-xor"
          "broadcast"
          "802.3ad"
          "balance-tlb"
          "balance-alb"
        ])
        (assertValueOneOf "TransmitHashPolicy" [
          "layer2"
          "layer3+4"
          "layer2+3"
          "encap2+3"
          "encap3+4"
        ])
        (assertValueOneOf "LACPTransmitRate" ["slow" "fast"])
        (assertValueOneOf "AdSelect" ["stable" "bandwidth" "count"])
        (assertInt "AdActorSystemPriority")
        (assertRange "AdActorSystemPriority" 1 65535)
        (assertInt "AdUserPortKey")
        (assertRange "AdUserPortKey" 0 1023)
        (assertValueOneOf "FailOverMACPolicy" ["none" "active" "follow"])
        (assertValueOneOf "ARPValidate" ["none" "active" "backup" "all"])
        (assertValueOneOf "ARPAllTargets" ["any" "all"])
        (assertValueOneOf "PrimaryReselectPolicy" ["always" "better" "failure"])
        (assertInt "ResendIGMP")
        (assertRange "ResendIGMP" 0 255)
        (assertInt "PacketsPerSlave")
        (assertRange "PacketsPerSlave" 0 65535)
        (assertInt "GratuitousARP")
        (assertRange "GratuitousARP" 0 255)
        (assertValueOneOf "AllSlavesActive" boolValues)
        (assertValueOneOf "DynamicTransmitLoadBalancing" boolValues)
        (assertInt "MinLinks")
        (assertMinimum "MinLinks" 0)
      ];

      sectionXfrm = checkUnitConfig "Xfrm" [
        (assertOnlyFields [
          "InterfaceId"
          "Independent"
        ])
        (assertInt "InterfaceId")
        (assertRange "InterfaceId" 1 4294967295)
        (assertValueOneOf "Independent" boolValues)
      ];

      sectionVRF = checkUnitConfig "VRF" [
        (assertOnlyFields [
          "Table"
        ])
        (assertInt "Table")
        (assertMinimum "Table" 0)
      ];
    };

    network = {

      sectionLink = checkUnitConfig "Link" [
        (assertOnlyFields [
          "MACAddress"
          "MTUBytes"
          "ARP"
          "Multicast"
          "AllMulticast"
          "Unmanaged"
          "RequiredForOnline"
        ])
        (assertMacAddress "MACAddress")
        (assertByteFormat "MTUBytes")
        (assertValueOneOf "ARP" boolValues)
        (assertValueOneOf "Multicast" boolValues)
        (assertValueOneOf "AllMulticast" boolValues)
        (assertValueOneOf "Unmanaged" boolValues)
        (assertValueOneOf "RequiredForOnline" (boolValues ++ [
          "missing"
          "off"
          "no-carrier"
          "dormant"
          "degraded-carrier"
          "carrier"
          "degraded"
          "enslaved"
          "routable"
        ]))
      ];

      sectionNetwork = checkUnitConfig "Network" [
        (assertOnlyFields [
          "Description"
          "DHCP"
          "DHCPServer"
          "LinkLocalAddressing"
          "IPv4LLRoute"
          "DefaultRouteOnDevice"
          "IPv6Token"
          "LLMNR"
          "MulticastDNS"
          "DNSOverTLS"
          "DNSSEC"
          "DNSSECNegativeTrustAnchors"
          "LLDP"
          "EmitLLDP"
          "BindCarrier"
          "Address"
          "Gateway"
          "DNS"
          "Domains"
          "DNSDefaultRoute"
          "NTP"
          "IPForward"
          "IPMasquerade"
          "IPv6PrivacyExtensions"
          "IPv6AcceptRA"
          "IPv6DuplicateAddressDetection"
          "IPv6HopLimit"
          "IPv4ProxyARP"
          "IPv6ProxyNDP"
          "IPv6ProxyNDPAddress"
          "IPv6PrefixDelegation"
          "IPv6MTUBytes"
          "Bridge"
          "Bond"
          "VRF"
          "VLAN"
          "IPVLAN"
          "MACVLAN"
          "VXLAN"
          "Tunnel"
          "MACsec"
          "ActiveSlave"
          "PrimarySlave"
          "ConfigureWithoutCarrier"
          "IgnoreCarrierLoss"
          "Xfrm"
          "KeepConfiguration"
        ])
        # Note: For DHCP the values both, none, v4, v6 are deprecated
        (assertValueOneOf "DHCP" ["yes" "no" "ipv4" "ipv6"])
        (assertValueOneOf "DHCPServer" boolValues)
        (assertValueOneOf "LinkLocalAddressing" ["yes" "no" "ipv4" "ipv6" "fallback" "ipv4-fallback"])
        (assertValueOneOf "IPv4LLRoute" boolValues)
        (assertValueOneOf "DefaultRouteOnDevice" boolValues)
        (assertValueOneOf "LLMNR" (boolValues ++ ["resolve"]))
        (assertValueOneOf "MulticastDNS" (boolValues ++ ["resolve"]))
        (assertValueOneOf "DNSOverTLS" (boolValues ++ ["opportunistic"]))
        (assertValueOneOf "DNSSEC" (boolValues ++ ["allow-downgrade"]))
        (assertValueOneOf "LLDP" (boolValues ++ ["routers-only"]))
        (assertValueOneOf "EmitLLDP" (boolValues ++ ["nearest-bridge" "non-tpmr-bridge" "customer-bridge"]))
        (assertValueOneOf "DNSDefaultRoute" boolValues)
        (assertValueOneOf "IPForward" (boolValues ++ ["ipv4" "ipv6"]))
        (assertValueOneOf "IPMasquerade" boolValues)
        (assertValueOneOf "IPv6PrivacyExtensions" (boolValues ++ ["prefer-public" "kernel"]))
        (assertValueOneOf "IPv6AcceptRA" boolValues)
        (assertInt "IPv6DuplicateAddressDetection")
        (assertMinimum "IPv6DuplicateAddressDetection" 0)
        (assertInt "IPv6HopLimit")
        (assertMinimum "IPv6HopLimit" 0)
        (assertValueOneOf "IPv4ProxyARP" boolValues)
        (assertValueOneOf "IPv6ProxyNDP" boolValues)
        (assertValueOneOf "IPv6PrefixDelegation" ["static" "dhcpv6" "yes" "false"])
        (assertByteFormat "IPv6MTUBytes")
        (assertValueOneOf "ActiveSlave" boolValues)
        (assertValueOneOf "PrimarySlave" boolValues)
        (assertValueOneOf "ConfigureWithoutCarrier" boolValues)
        (assertValueOneOf "IgnoreCarrierLoss" boolValues)
        (assertValueOneOf "KeepConfiguration" (boolValues ++ ["static" "dhcp-on-stop" "dhcp"]))
      ];

      sectionAddress = checkUnitConfig "Address" [
        (assertOnlyFields [
          "Address"
          "Peer"
          "Broadcast"
          "Label"
          "PreferredLifetime"
          "Scope"
          "HomeAddress"
          "DuplicateAddressDetection"
          "ManageTemporaryAddress"
          "AddPrefixRoute"
          "AutoJoin"
        ])
        (assertHasField "Address")
        (assertValueOneOf "PreferredLifetime" ["forever" "infinity" "0" 0])
        (assertValueOneOf "HomeAddress" boolValues)
        (assertValueOneOf "DuplicateAddressDetection" ["ipv4" "ipv6" "both" "none"])
        (assertValueOneOf "ManageTemporaryAddress" boolValues)
        (assertValueOneOf "AddPrefixRoute" boolValues)
        (assertValueOneOf "AutoJoin" boolValues)
      ];

      sectionRoutingPolicyRule = checkUnitConfig "RoutingPolicyRule" [
        (assertOnlyFields [
          "TypeOfService"
          "From"
          "To"
          "FirewallMark"
          "Table"
          "Priority"
          "IncomingInterface"
          "OutgoingInterface"
          "SourcePort"
          "DestinationPort"
          "IPProtocol"
          "InvertRule"
          "Family"
          "User"
          "SuppressPrefixLength"
        ])
        (assertInt "TypeOfService")
        (assertRange "TypeOfService" 0 255)
        (assertInt "FirewallMark")
        (assertRange "FirewallMark" 1 4294967295)
        (assertInt "Priority")
        (assertPort "SourcePort")
        (assertPort "DestinationPort")
        (assertValueOneOf "InvertRule" boolValues)
        (assertValueOneOf "Family" ["ipv4" "ipv6" "both"])
        (assertInt "SuppressPrefixLength")
        (assertRange "SuppressPrefixLength" 0 128)
      ];

      sectionRoute = checkUnitConfig "Route" [
        (assertOnlyFields [
          "Gateway"
          "GatewayOnLink"
          "Destination"
          "Source"
          "Metric"
          "IPv6Preference"
          "Scope"
          "PreferredSource"
          "Table"
          "Protocol"
          "Type"
          "InitialCongestionWindow"
          "InitialAdvertisedReceiveWindow"
          "QuickAck"
          "FastOpenNoCookie"
          "TTLPropagate"
          "MTUBytes"
          "IPServiceType"
          "MultiPathRoute"
        ])
        (assertValueOneOf "GatewayOnLink" boolValues)
        (assertInt "Metric")
        (assertValueOneOf "IPv6Preference" ["low" "medium" "high"])
        (assertValueOneOf "Scope" ["global" "site" "link" "host" "nowhere"])
        (assertValueOneOf "Type" [
          "unicast"
          "local"
          "broadcast"
          "anycast"
          "multicast"
          "blackhole"
          "unreachable"
          "prohibit"
          "throw"
          "nat"
          "xresolve"
        ])
        (assertValueOneOf "QuickAck" boolValues)
        (assertValueOneOf "FastOpenNoCookie" boolValues)
        (assertValueOneOf "TTLPropagate" boolValues)
        (assertByteFormat "MTUBytes")
        (assertValueOneOf "IPServiceType" ["CS6" "CS4"])
      ];

      sectionDHCPv4 = checkUnitConfig "DHCPv4" [
        (assertOnlyFields [
          "UseDNS"
          "RoutesToDNS"
          "UseNTP"
          "UseSIP"
          "UseMTU"
          "Anonymize"
          "SendHostname"
          "UseHostname"
          "Hostname"
          "UseDomains"
          "UseRoutes"
          "UseTimezone"
          "ClientIdentifier"
          "VendorClassIdentifier"
          "UserClass"
          "MaxAttempts"
          "DUIDType"
          "DUIDRawData"
          "IAID"
          "RequestBroadcast"
          "RouteMetric"
          "RouteTable"
          "RouteMTUBytes"
          "ListenPort"
          "SendRelease"
          "SendDecline"
          "BlackList"
          "RequestOptions"
          "SendOption"
        ])
        (assertValueOneOf "UseDNS" boolValues)
        (assertValueOneOf "RoutesToDNS" boolValues)
        (assertValueOneOf "UseNTP" boolValues)
        (assertValueOneOf "UseSIP" boolValues)
        (assertValueOneOf "UseMTU" boolValues)
        (assertValueOneOf "Anonymize" boolValues)
        (assertValueOneOf "SendHostname" boolValues)
        (assertValueOneOf "UseHostname" boolValues)
        (assertValueOneOf "UseDomains" (boolValues ++ ["route"]))
        (assertValueOneOf "UseRoutes" boolValues)
        (assertValueOneOf "UseTimezone" boolValues)
        (assertValueOneOf "ClientIdentifier" ["mac" "duid" "duid-only"])
        (assertInt "IAID")
        (assertValueOneOf "RequestBroadcast" boolValues)
        (assertInt "RouteMetric")
        (assertInt "RouteTable")
        (assertRange "RouteTable" 0 4294967295)
        (assertByteFormat "RouteMTUBytes")
        (assertPort "ListenPort")
        (assertValueOneOf "SendRelease" boolValues)
        (assertValueOneOf "SendDecline" boolValues)
      ];

      sectionDHCPv6 = checkUnitConfig "DHCPv6" [
        (assertOnlyFields [
          "UseDNS"
          "UseNTP"
          "RapidCommit"
          "ForceDHCPv6PDOtherInformation"
          "PrefixDelegationHint"
        ])
        (assertValueOneOf "UseDNS" boolValues)
        (assertValueOneOf "UseNTP" boolValues)
        (assertValueOneOf "RapidCommit" boolValues)
        (assertValueOneOf "ForceDHCPv6PDOtherInformation" boolValues)
      ];

      sectionDHCPServer = checkUnitConfig "DHCPServer" [
        (assertOnlyFields [
          "PoolOffset"
          "PoolSize"
          "DefaultLeaseTimeSec"
          "MaxLeaseTimeSec"
          "EmitDNS"
          "DNS"
          "EmitNTP"
          "NTP"
          "EmitSIP"
          "SIP"
          "EmitRouter"
          "EmitTimezone"
          "Timezone"
          "SendOption"
        ])
        (assertInt "PoolOffset")
        (assertMinimum "PoolOffset" 0)
        (assertInt "PoolSize")
        (assertMinimum "PoolSize" 0)
        (assertValueOneOf "EmitDNS" boolValues)
        (assertValueOneOf "EmitNTP" boolValues)
        (assertValueOneOf "EmitSIP" boolValues)
        (assertValueOneOf "EmitRouter" boolValues)
        (assertValueOneOf "EmitTimezone" boolValues)
      ];

      sectionIPv6PrefixDelegation = checkUnitConfig "IPv6PrefixDelegation" [
        (assertOnlyFields [
          "Managed"
          "OtherInformation"
          "RouterLifetimeSec"
          "RouterPreference"
          "EmitDNS"
          "DNS"
          "EmitDomains"
          "Domains"
          "DNSLifetimeSec"
        ])
        (assertValueOneOf "Managed" boolValues)
        (assertValueOneOf "OtherInformation" boolValues)
        (assertValueOneOf "RouterPreference" ["high" "medium" "low" "normal" "default"])
        (assertValueOneOf "EmitDNS" boolValues)
        (assertValueOneOf "EmitDomains" boolValues)
      ];

      sectionIPv6Prefix = checkUnitConfig "IPv6Prefix" [
        (assertOnlyFields [
          "AddressAutoconfiguration"
          "OnLink"
          "Prefix"
          "PreferredLifetimeSec"
          "ValidLifetimeSec"
        ])
        (assertValueOneOf "AddressAutoconfiguration" boolValues)
        (assertValueOneOf "OnLink" boolValues)
      ];

    };
  };

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
      type = types.addCheck (types.attrsOf unitOption) check.link.sectionLink;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Link]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.link</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  wireguardPeerOptions = {
    options = {
      wireguardPeerConfig = mkOption {
        default = {};
        example = { };
        type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionWireGuardPeer;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[WireGuardPeer]</literal> section of the unit.  See
          <citerefentry><refentrytitle>systemd.network</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };
  };

  netdevOptions = commonNetworkOptions // {

    netdevConfig = mkOption {
      default = {};
      example = { Name = "mybridge"; Kind = "bridge"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionNetdev;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Netdev]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vlanConfig = mkOption {
      default = {};
      example = { Id = 4; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVLAN;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionMACVLAN;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVXLAN;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTunnel;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionPeer;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTun;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTap;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tap]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    wireguardConfig = mkOption {
      default = {};
      example = {
        PrivateKeyFile = "/etc/wireguard/secret.key";
        ListenPort = 51820;
        FwMark = 42;
      };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionWireGuard;
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

    bondConfig = mkOption {
      default = {};
      example = { Mode = "802.3ad"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionBond;
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
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionXfrm;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Xfrm]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vrfConfig = mkOption {
      default = {};
      example = { Table = 2342; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVRF;
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

  };

  addressOptions = {
    options = {
      addressConfig = mkOption {
        default = {};
        example = { Address = "192.168.0.100/24"; };
        type = types.addCheck (types.attrsOf unitOption) check.network.sectionAddress;
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
        type = types.addCheck (types.attrsOf unitOption) check.network.sectionRoutingPolicyRule;
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
        type = types.addCheck (types.attrsOf unitOption) check.network.sectionRoute;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Route]</literal> section of the unit.  See
          <citerefentry><refentrytitle>systemd.network</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };
  };

  ipv6PrefixOptions = {
    options = {
      ipv6PrefixConfig = mkOption {
        default = {};
        example = { Prefix = "fd00::/64"; };
        type = types.addCheck (types.attrsOf unitOption) check.network.sectionIPv6Prefix;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[IPv6Prefix]</literal> section of the unit.  See
          <citerefentry><refentrytitle>systemd.network</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };
  };

  networkOptions = commonNetworkOptions // {

    linkConfig = mkOption {
      default = {};
      example = { Unmanaged = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionLink;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Link]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    networkConfig = mkOption {
      default = {};
      example = { Description = "My Network"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionNetwork;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Network]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    # systemd.network.networks.*.dhcpConfig has been deprecated in favor of ….dhcpV4Config
    # Produce a nice warning message so users know it is gone.
    dhcpConfig = mkOption {
      visible = false;
      apply = _: throw "The option `systemd.network.networks.*.dhcpConfig` can no longer be used since it's been removed. Please use `systemd.network.networks.*.dhcpV4Config` instead.";
    };

    dhcpV4Config = mkOption {
      default = {};
      example = { UseDNS = true; UseRoutes = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPv4;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCPv4]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dhcpV6Config = mkOption {
      default = {};
      example = { UseDNS = true; UseRoutes = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPv6;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCPv6]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dhcpServerConfig = mkOption {
      default = {};
      example = { PoolOffset = 50; EmitDNS = false; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPServer;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCPServer]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    ipv6PrefixDelegationConfig = mkOption {
      default = {};
      example = { EmitDNS = true; Managed = true; OtherInformation = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionIPv6PrefixDelegation;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[IPv6PrefixDelegation]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    ipv6Prefixes = mkOption {
      default = [];
      example = { AddressAutoconfiguration = true; OnLink = true; };
      type = with types; listOf (submodule ipv6PrefixOptions);
      description = ''
        A list of ipv6Prefix sections to be added to the unit.  See
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

  commonMatchText = def: optionalString (def.matchConfig != { }) ''
    [Match]
    ${attrsToSection def.matchConfig}
  '';

  linkToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def
        + ''
          [Link]
          ${attrsToSection def.linkConfig}
        ''
        + def.extraConfig;
    };

  netdevToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def
        + ''
          [NetDev]
          ${attrsToSection def.netdevConfig}
        ''
        + optionalString (def.vlanConfig != { }) ''
          [VLAN]
          ${attrsToSection def.vlanConfig}
        ''
        + optionalString (def.macvlanConfig != { }) ''
          [MACVLAN]
          ${attrsToSection def.macvlanConfig}
        ''
        + optionalString (def.vxlanConfig != { }) ''
          [VXLAN]
          ${attrsToSection def.vxlanConfig}
        ''
        + optionalString (def.tunnelConfig != { }) ''
          [Tunnel]
          ${attrsToSection def.tunnelConfig}
        ''
        + optionalString (def.peerConfig != { }) ''
          [Peer]
          ${attrsToSection def.peerConfig}
        ''
        + optionalString (def.tunConfig != { }) ''
          [Tun]
          ${attrsToSection def.tunConfig}
        ''
        + optionalString (def.tapConfig != { }) ''
          [Tap]
          ${attrsToSection def.tapConfig}
        ''
        + optionalString (def.wireguardConfig != { }) ''
          [WireGuard]
          ${attrsToSection def.wireguardConfig}
        ''
        + flip concatMapStrings def.wireguardPeers (x: ''
          [WireGuardPeer]
          ${attrsToSection x.wireguardPeerConfig}
        '')
        + optionalString (def.bondConfig != { }) ''
          [Bond]
          ${attrsToSection def.bondConfig}
        ''
        + optionalString (def.xfrmConfig != { }) ''
          [Xfrm]
          ${attrsToSection def.xfrmConfig}
        ''
        + optionalString (def.vrfConfig != { }) ''
          [VRF]
          ${attrsToSection def.vrfConfig}
        ''
        + def.extraConfig;
    };

  networkToUnit = name: def:
    { inherit (def) enable;
      text = commonMatchText def
        + optionalString (def.linkConfig != { }) ''
          [Link]
          ${attrsToSection def.linkConfig}
        ''
        + ''
          [Network]
        ''
        + attrsToSection def.networkConfig
        + optionalString (def.address != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Address=${s}") def.address)}
        ''
        + optionalString (def.gateway != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Gateway=${s}") def.gateway)}
        ''
        + optionalString (def.dns != [ ]) ''
          ${concatStringsSep "\n" (map (s: "DNS=${s}") def.dns)}
        ''
        + optionalString (def.ntp != [ ]) ''
          ${concatStringsSep "\n" (map (s: "NTP=${s}") def.ntp)}
        ''
        + optionalString (def.bridge != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Bridge=${s}") def.bridge)}
        ''
        + optionalString (def.bond != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Bond=${s}") def.bond)}
        ''
        + optionalString (def.vrf != [ ]) ''
          ${concatStringsSep "\n" (map (s: "VRF=${s}") def.vrf)}
        ''
        + optionalString (def.vlan != [ ]) ''
          ${concatStringsSep "\n" (map (s: "VLAN=${s}") def.vlan)}
        ''
        + optionalString (def.macvlan != [ ]) ''
          ${concatStringsSep "\n" (map (s: "MACVLAN=${s}") def.macvlan)}
        ''
        + optionalString (def.vxlan != [ ]) ''
          ${concatStringsSep "\n" (map (s: "VXLAN=${s}") def.vxlan)}
        ''
        + optionalString (def.tunnel != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Tunnel=${s}") def.tunnel)}
        ''
        + optionalString (def.xfrm != [ ]) ''
          ${concatStringsSep "\n" (map (s: "Xfrm=${s}") def.xfrm)}
        ''
        + ''

        ''
        + flip concatMapStrings def.addresses (x: ''
          [Address]
          ${attrsToSection x.addressConfig}
        '')
        + flip concatMapStrings def.routingPolicyRules (x: ''
          [RoutingPolicyRule]
          ${attrsToSection x.routingPolicyRuleConfig}
        '')
        + flip concatMapStrings def.routes (x: ''
          [Route]
          ${attrsToSection x.routeConfig}
        '')
        + optionalString (def.dhcpV4Config != { }) ''
          [DHCPv4]
          ${attrsToSection def.dhcpV4Config}
        ''
        + optionalString (def.dhcpV6Config != { }) ''
          [DHCPv6]
          ${attrsToSection def.dhcpV6Config}
        ''
        + optionalString (def.dhcpServerConfig != { }) ''
          [DHCPServer]
          ${attrsToSection def.dhcpServerConfig}
        ''
        + optionalString (def.ipv6PrefixDelegationConfig != { }) ''
          [IPv6PrefixDelegation]
          ${attrsToSection def.ipv6PrefixDelegationConfig}
        ''
        + flip concatMapStrings def.ipv6Prefixes (x: ''
          [IPv6Prefix]
          ${attrsToSection x.ipv6PrefixConfig}
        '')
        + def.extraConfig;
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
        "systemd-networkd-wait-online.service"
        "systemd-networkd.service"
        "systemd-networkd.socket"
      ];

      systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.netdev" (netdevToUnit n v)) cfg.netdevs
        // mapAttrs' (n: v: nameValuePair "${n}.network" (networkToUnit n v)) cfg.networks;

      # systemd-networkd is socket-activated by kernel netlink route change
      # messages. It is important to have systemd buffer those on behalf of
      # networkd.
      systemd.sockets.systemd-networkd.wantedBy = [ "sockets.target" ];

      systemd.services.systemd-networkd = {
        wantedBy = [ "multi-user.target" ];
        aliases = [ "dbus-org.freedesktop.network1.service" ];
        restartTriggers = map (x: x.source) (attrValues unitFiles);
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
