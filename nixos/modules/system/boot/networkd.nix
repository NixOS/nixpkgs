{ config, lib, pkgs, utils, ... }:

with utils.systemdUtils.unitOptions;
with utils.systemdUtils.lib;
with utils.systemdUtils.network.units;
with lib;

let

  check = {

    global = {
      sectionNetwork = checkUnitConfig "Network" [
        (assertOnlyFields [
          "SpeedMeter"
          "SpeedMeterIntervalSec"
          "ManageForeignRoutingPolicyRules"
          "ManageForeignRoutes"
          "RouteTable"
          "IPv6PrivacyExtensions"
          "IPv4Forwarding"
          "IPv6Forwarding"
        ])
        (assertValueOneOf "SpeedMeter" boolValues)
        (assertInt "SpeedMeterIntervalSec")
        (assertValueOneOf "ManageForeignRoutingPolicyRules" boolValues)
        (assertValueOneOf "ManageForeignRoutes" boolValues)
        (assertValueOneOf "IPv6PrivacyExtensions" (boolValues ++ ["prefer-public" "kernel"]))
        (assertValueOneOf "IPv4Forwarding" boolValues)
        (assertValueOneOf "IPv6Forwarding" boolValues)
      ];

      sectionDHCPv4 = checkUnitConfig "DHCPv4" [
        (assertOnlyFields [
          "ClientIdentifier"
          "DUIDType"
          "DUIDRawData"
        ])
        (assertValueOneOf "ClientIdentifier" ["mac" "duid" "duid-only"])
      ];

      sectionDHCPv6 = checkUnitConfig "DHCPv6" [
        (assertOnlyFields [
          "DUIDType"
          "DUIDRawData"
        ])
      ];
    };

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
          "ReceiveQueues"
          "TransmitQueues"
          "TransmitQueueLength"
        ])
        (assertValueOneOf "MACAddressPolicy" ["persistent" "random" "none"])
        (assertMacAddress "MACAddress")
        (assertByteFormat "MTUBytes")
        (assertByteFormat "BitsPerSecond")
        (assertValueOneOf "Duplex" ["half" "full"])
        (assertValueOneOf "AutoNegotiation" boolValues)
        (assertValuesSomeOfOr "WakeOnLan" ["phy" "unicast" "multicast" "broadcast" "arp" "magic" "secureon"] "off")
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
        (assertRange "ReceiveQueues" 1 4096)
        (assertRange "TransmitQueues" 1 4096)
        (assertRange "TransmitQueueLength" 1 4294967294)
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
          "KeepCarrier"
        ])
        (assertValueOneOf "MultiQueue" boolValues)
        (assertValueOneOf "PacketInfo" boolValues)
        (assertValueOneOf "VNetHeader" boolValues)
        (assertValueOneOf "KeepCarrier" boolValues)
      ];

      # See https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html#%5BIPVTAP%5D%20Section%20Options
      ipVlanVtapChecks = [
        (assertOnlyFields [
          "Mode"
          "Flags"
        ])
        (assertValueOneOf "Mode" ["L2" "L3" "L3S" ])
        (assertValueOneOf "Flags" ["private" "vepa" "bridge" ])
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
          "ipvtap"
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
          "wlan"
          "vrf"
          "vcan"
          "vxcan"
          "wireguard"
          "netdevsim"
          "nlmon"
          "fou"
          "xfrm"
          "ifb"
          "batadv"
        ])
        (assertByteFormat "MTUBytes")
        (assertNetdevMacAddress "MACAddress")
      ];

      sectionBridge = checkUnitConfig "Bridge" [
        (assertOnlyFields [
          "HelloTimeSec"
          "MaxAgeSec"
          "ForwardDelaySec"
          "AgeingTimeSec"
          "Priority"
          "GroupForwardMask"
          "DefaultPVID"
          "MulticastQuerier"
          "MulticastSnooping"
          "VLANFiltering"
          "VLANProtocol"
          "STP"
          "MulticastIGMPVersion"
        ])
        (assertInt "HelloTimeSec")
        (assertInt "MaxAgeSec")
        (assertInt "ForwardDelaySec")
        (assertInt "AgeingTimeSec")
        (assertRange "Priority" 0 65535)
        (assertRange "GroupForwardMask" 0 65535)
        (assertRangeOrOneOf "DefaultPVID" 0 4094 ["none"])
        (assertValueOneOf "MulticastQuerier" boolValues)
        (assertValueOneOf "MulticastSnooping" boolValues)
        (assertValueOneOf "VLANFiltering" boolValues)
        (assertValueOneOf "VLANProtocol" ["802.1q" "802.ad"])
        (assertValueOneOf "STP" boolValues)
        (assertValueOneOf "MulticastIGMPVersion" [2 3])
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

      sectionIPVLAN = checkUnitConfig "IPVLAN" ipVlanVtapChecks;

      sectionIPVTAP = checkUnitConfig "IPVTAP" ipVlanVtapChecks;

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
          "Independent"
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
        (assertValueOneOf "Independent" boolValues)
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

      sectionFooOverUDP = checkUnitConfig "FooOverUDP" [
        (assertOnlyFields [
          "Port"
          "Encapsulation"
          "Protocol"
        ])
        (assertPort "Port")
        (assertValueOneOf "Encapsulation" ["FooOverUDP" "GenericUDPEncapsulation"])
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

      sectionL2TP = checkUnitConfig "L2TP" [
        (assertOnlyFields [
          "TunnelId"
          "PeerTunnelId"
          "Remote"
          "Local"
          "EncapsulationType"
          "UDPSourcePort"
          "UDPDestinationPort"
          "UDPChecksum"
          "UDP6ZeroChecksumTx"
          "UDP6ZeroChecksumRx"
        ])
        (assertInt "TunnelId")
        (assertRange "TunnelId" 1 4294967295)
        (assertInt "PeerTunnelId")
        (assertRange "PeerTunnelId" 1 4294967295)
        (assertValueOneOf "EncapsulationType" [ "ip" "udp" ])
        (assertPort "UDPSourcePort")
        (assertPort "UDPDestinationPort")
        (assertValueOneOf "UDPChecksum" boolValues)
        (assertValueOneOf "UDP6ZeroChecksumTx" boolValues)
        (assertValueOneOf "UDP6ZeroChecksumRx" boolValues)
      ];

      sectionL2TPSession = checkUnitConfigWithLegacyKey "l2tpSessionConfig" "L2TPSession" [
        (assertOnlyFields [
          "Name"
          "SessionId"
          "PeerSessionId"
          "Layer2SpecificHeader"
        ])
        (assertHasField "Name")
        (assertHasField "SessionId")
        (assertInt "SessionId")
        (assertRange "SessionId" 1 4294967295)
        (assertHasField "PeerSessionId")
        (assertInt "PeerSessionId")
        (assertRange "PeerSessionId" 1 4294967295)
        (assertValueOneOf "Layer2SpecificHeader" [ "none" "default" ])
      ];

      # NOTE The PrivateKey directive is missing on purpose here, please
      # do not add it to this list. The nix store is world-readable let's
      # refrain ourselves from providing a footgun.
      sectionWireGuard = checkUnitConfig "WireGuard" [
        (assertOnlyFields [
          "PrivateKeyFile"
          "ListenPort"
          "FirewallMark"
          "RouteTable"
          "RouteMetric"
        ])
        (assertInt "FirewallMark")
        (assertRange "FirewallMark" 1 4294967295)
      ];

      # NOTE The PresharedKey directive is missing on purpose here, please
      # do not add it to this list. The nix store is world-readable,let's
      # refrain ourselves from providing a footgun.
      sectionWireGuardPeer = checkUnitConfigWithLegacyKey "wireguardPeerConfig" "WireGuardPeer" [
        (assertOnlyFields [
          "PublicKey"
          "PresharedKeyFile"
          "AllowedIPs"
          "Endpoint"
          "PersistentKeepalive"
          "RouteTable"
          "RouteMetric"
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

      sectionWLAN = checkUnitConfig "WLAN" [
        (assertOnlyFields [
          "PhysicalDevice"  # systemd supports both strings ("phy0") and indexes (0) here.
          "Type"
          "WDS"
        ])
        # See https://github.com/systemd/systemd/blob/main/src/basic/linux/nl80211.h#L3382
        (assertValueOneOf "Type" [
          "ad-hoc"
          "station"
          "ap"
          "ap-vlan"
          "wds"
          "monitor"
          "mesh-point"
          "p2p-client"
          "p2p-go"
          "p2p-device"
          "ocb"
          "nan"
        ])
        (assertValueOneOf "WDS" boolValues)
      ];

      sectionBatmanAdvanced = checkUnitConfig "BatmanAdvanced" [
        (assertOnlyFields [
          "GatewayMode"
          "Aggregation"
          "BridgeLoopAvoidance"
          "DistributedArpTable"
          "Fragmentation"
          "HopPenalty"
          "OriginatorIntervalSec"
          "GatewayBandwithDown"
          "GatewayBandwithUp"
          "RoutingAlgorithm"
        ])
        (assertValueOneOf "GatewayMode" ["off" "client" "server"])
        (assertValueOneOf "Aggregation" boolValues)
        (assertValueOneOf "BridgeLoopAvoidance" boolValues)
        (assertValueOneOf "DistributedArpTable" boolValues)
        (assertValueOneOf "Fragmentation" boolValues)
        (assertInt "HopPenalty")
        (assertRange "HopPenalty" 0 255)
        (assertValueOneOf "RoutingAlgorithm" ["batman-v" "batman-iv"])
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
          "Group"
          "RequiredForOnline"
          "RequiredFamilyForOnline"
          "ActivationPolicy"
          "Promiscuous"
        ])
        (assertMacAddress "MACAddress")
        (assertByteFormat "MTUBytes")
        (assertValueOneOf "ARP" boolValues)
        (assertValueOneOf "Multicast" boolValues)
        (assertValueOneOf "AllMulticast" boolValues)
        (assertValueOneOf "Promiscuous" boolValues)
        (assertValueOneOf "Unmanaged" boolValues)
        (assertInt "Group")
        (assertRange "Group" 0 2147483647)
        (assertValueOneOf "RequiredForOnline" (boolValues ++ (
          let
            # https://freedesktop.org/software/systemd/man/networkctl.html#missing
            operationalStates = [
              "missing"
              "off"
              "no-carrier"
              "dormant"
              "degraded-carrier"
              "carrier"
              "degraded"
              "enslaved"
              "routable"
            ];
            operationalStateRanges = concatLists (imap0 (i: min: map (max: "${min}:${max}") (drop i operationalStates)) operationalStates);
          in
          operationalStates ++ operationalStateRanges
        )))
        (assertValueOneOf "RequiredFamilyForOnline" [
          "ipv4"
          "ipv6"
          "both"
          "any"
        ])
        (assertValueOneOf "ActivationPolicy" ([
          "up"
          "always-up"
          "manual"
          "always-down"
          "down"
          "bound"
        ]))
      ];

      sectionNetwork = checkUnitConfig "Network" [
        (assertOnlyFields [
          "Description"
          "DHCP"
          "DHCPServer"
          "LinkLocalAddressing"
          "IPv6LinkLocalAddressGenerationMode"
          "IPv6StableSecretAddress"
          "IPv4LLStartAddress"
          "IPv4LLRoute"
          "DefaultRouteOnDevice"
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
          "IPv4Forwarding"
          "IPv6Forwarding"
          "IPMasquerade"
          "IPv6PrivacyExtensions"
          "IPv6AcceptRA"
          "IPv6DuplicateAddressDetection"
          "IPv6HopLimit"
          "IPv4ReversePathFilter"
          "IPv4AcceptLocal"
          "IPv4RouteLocalnet"
          "IPv4ProxyARP"
          "IPv6ProxyNDP"
          "IPv6ProxyNDPAddress"
          "IPv6SendRA"
          "DHCPPrefixDelegation"
          "IPv6MTUBytes"
          "KeepMaster"
          "Bridge"
          "Bond"
          "VRF"
          "VLAN"
          "IPVLAN"
          "IPVTAP"
          "MACVLAN"
          "MACVTAP"
          "VXLAN"
          "Tunnel"
          "MACsec"
          "ActiveSlave"
          "PrimarySlave"
          "ConfigureWithoutCarrier"
          "IgnoreCarrierLoss"
          "Xfrm"
          "KeepConfiguration"
          "BatmanAdvanced"
        ])
        # Note: For DHCP the values both, none, v4, v6 are deprecated
        (assertValueOneOf "DHCP" (boolValues ++ ["ipv4" "ipv6"]))
        (assertValueOneOf "DHCPServer" boolValues)
        (assertValueOneOf "LinkLocalAddressing" (boolValues ++ ["ipv4" "ipv6" "fallback" "ipv4-fallback"]))
        (assertValueOneOf "IPv6LinkLocalAddressGenerationMode" ["eui64" "none" "stable-privacy" "random"])
        (assertValueOneOf "IPv4LLRoute" boolValues)
        (assertValueOneOf "DefaultRouteOnDevice" boolValues)
        (assertValueOneOf "LLMNR" (boolValues ++ ["resolve"]))
        (assertValueOneOf "MulticastDNS" (boolValues ++ ["resolve"]))
        (assertValueOneOf "DNSOverTLS" (boolValues ++ ["opportunistic"]))
        (assertValueOneOf "DNSSEC" (boolValues ++ ["allow-downgrade"]))
        (assertValueOneOf "LLDP" (boolValues ++ ["routers-only"]))
        (assertValueOneOf "EmitLLDP" (boolValues ++ ["nearest-bridge" "non-tpmr-bridge" "customer-bridge"]))
        (assertValueOneOf "DNSDefaultRoute" boolValues)
        (assertRemoved "IPForward" "IPv4Forwarding and IPv6Forwarding in systemd.network(5) and networkd.conf(5)")
        (assertValueOneOf "IPv4Forwarding" boolValues)
        (assertValueOneOf "IPv6Forwarding" boolValues)
        (assertValueOneOf "IPMasquerade" (boolValues ++ ["ipv4" "ipv6" "both"]))
        (assertValueOneOf "IPv6PrivacyExtensions" (boolValues ++ ["prefer-public" "kernel"]))
        (assertValueOneOf "IPv6AcceptRA" boolValues)
        (assertInt "IPv6DuplicateAddressDetection")
        (assertMinimum "IPv6DuplicateAddressDetection" 0)
        (assertInt "IPv6HopLimit")
        (assertMinimum "IPv6HopLimit" 0)
        (assertValueOneOf "IPv4ReversePathFilter" ["no" "strict" "loose"])
        (assertValueOneOf "IPv4AcceptLocal" boolValues)
        (assertValueOneOf "IPv4RouteLocalnet" boolValues)
        (assertValueOneOf "IPv4ProxyARP" boolValues)
        (assertValueOneOf "IPv6ProxyNDP" boolValues)
        (assertValueOneOf "IPv6SendRA" boolValues)
        (assertValueOneOf "DHCPPrefixDelegation" boolValues)
        (assertByteFormat "IPv6MTUBytes")
        (assertValueOneOf "KeepMaster" boolValues)
        (assertValueOneOf "ActiveSlave" boolValues)
        (assertValueOneOf "PrimarySlave" boolValues)
        (assertValueOneOf "ConfigureWithoutCarrier" boolValues)
        (assertValueOneOf "KeepConfiguration" (boolValues ++ ["static" "dhcp-on-stop" "dhcp"]))
      ];

      sectionAddress = checkUnitConfigWithLegacyKey "addressConfig" "Address" [
        (assertOnlyFields [
          "Address"
          "Peer"
          "Broadcast"
          "Label"
          "PreferredLifetime"
          "Scope"
          "RouteMetric"
          "HomeAddress"
          "DuplicateAddressDetection"
          "ManageTemporaryAddress"
          "AddPrefixRoute"
          "AutoJoin"
        ])
        (assertHasField "Address")
        (assertValueOneOf "PreferredLifetime" ["forever" "infinity" "0" 0])
        (assertInt "RouteMetric")
        (assertValueOneOf "HomeAddress" boolValues)
        (assertValueOneOf "DuplicateAddressDetection" ["ipv4" "ipv6" "both" "none"])
        (assertValueOneOf "ManageTemporaryAddress" boolValues)
        (assertValueOneOf "AddPrefixRoute" boolValues)
        (assertValueOneOf "AutoJoin" boolValues)
      ];

      sectionRoutingPolicyRule = checkUnitConfigWithLegacyKey "routingPolicyRuleConfig" "RoutingPolicyRule" [
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
          "Type"
          "SuppressInterfaceGroup"
        ])
        (assertInt "TypeOfService")
        (assertRange "TypeOfService" 0 255)
        (assertRangeWithOptionalMask "FirewallMark" 1 4294967295)
        (assertInt "Priority")
        (assertPortOrPortRange "SourcePort")
        (assertPortOrPortRange "DestinationPort")
        (assertValueOneOf "InvertRule" boolValues)
        (assertValueOneOf "Family" ["ipv4" "ipv6" "both"])
        (assertInt "SuppressPrefixLength")
        (assertRange "SuppressPrefixLength" 0 128)
        (assertValueOneOf "Type" ["blackhole" "unreachable" "prohibit"])
        (assertRange "SuppressInterfaceGroup" 0 2147483647)
      ];

      sectionRoute = checkUnitConfigWithLegacyKey "routeConfig" "Route" [
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
          "UseGateway"
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
          "FallbackLeaseLifetimeSec"
          "Label"
          "Use6RD"
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
        (assertValueOneOf "UseGateway" boolValues)
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
        (assertValueOneOf "FallbackLeaseLifetimeSec" ["forever" "infinity"])
        (assertValueOneOf "Use6RD" boolValues)
      ];

      sectionDHCPv6 = checkUnitConfig "DHCPv6" [
        (assertOnlyFields [
          "UseAddress"
          "UseDNS"
          "UseNTP"
          "UseHostname"
          "UseDomains"
          "RouteMetric"
          "RapidCommit"
          "MUDURL"
          "RequestOptions"
          "SendVendorOption"
          "PrefixDelegationHint"
          "WithoutRA"
          "SendOption"
          "UserClass"
          "VendorClass"
          "DUIDType"
          "DUIDRawData"
          "IAID"
          "UseDelegatedPrefix"
          "SendRelease"
        ])
        (assertValueOneOf "UseAddress" boolValues)
        (assertValueOneOf "UseDNS" boolValues)
        (assertValueOneOf "UseNTP" boolValues)
        (assertValueOneOf "UseHostname" boolValues)
        (assertValueOneOf "UseDomains" (boolValues ++ ["route"]))
        (assertInt "RouteMetric")
        (assertValueOneOf "RapidCommit" boolValues)
        (assertValueOneOf "WithoutRA" ["no" "solicit" "information-request"])
        (assertRange "SendOption" 1 65536)
        (assertInt "IAID")
        (assertValueOneOf "UseDelegatedPrefix" boolValues)
        (assertValueOneOf "SendRelease" boolValues)
      ];

      sectionDHCPPrefixDelegation = checkUnitConfig "DHCPPrefixDelegation" [
        (assertOnlyFields [
          "UplinkInterface"
          "SubnetId"
          "Announce"
          "Assign"
          "Token"
          "ManageTemporaryAddress"
          "RouteMetric"
        ])
        (assertValueOneOf "Announce" boolValues)
        (assertValueOneOf "Assign" boolValues)
        (assertValueOneOf "ManageTemporaryAddress" boolValues)
        (assertRange "RouteMetric" 0 4294967295)
      ];

      sectionIPv6AcceptRA = checkUnitConfig "IPv6AcceptRA" [
        (assertOnlyFields [
          "UseDNS"
          "UseDomains"
          "RouteTable"
          "UseAutonomousPrefix"
          "UseOnLinkPrefix"
          "RouterDenyList"
          "RouterAllowList"
          "PrefixDenyList"
          "PrefixAllowList"
          "RouteDenyList"
          "RouteAllowList"
          "DHCPv6Client"
          "RouteMetric"
          "UseMTU"
          "UseGateway"
          "UseRoutePrefix"
          "Token"
          "UsePREF64"
        ])
        (assertValueOneOf "UseDNS" boolValues)
        (assertValueOneOf "UseDomains" (boolValues ++ ["route"]))
        (assertRange "RouteTable" 0 4294967295)
        (assertValueOneOf "UseAutonomousPrefix" boolValues)
        (assertValueOneOf "UseOnLinkPrefix" boolValues)
        (assertValueOneOf "DHCPv6Client" (boolValues ++ ["always"]))
        (assertValueOneOf "UseMTU" boolValues)
        (assertValueOneOf "UseGateway" boolValues)
        (assertValueOneOf "UseRoutePrefix" boolValues)
        (assertValueOneOf "UsePREF64" boolValues)
      ];

      sectionDHCPServer = checkUnitConfig "DHCPServer" [
        (assertOnlyFields [
          "ServerAddress"
          "PoolOffset"
          "PoolSize"
          "DefaultLeaseTimeSec"
          "MaxLeaseTimeSec"
          "UplinkInterface"
          "EmitDNS"
          "DNS"
          "EmitNTP"
          "NTP"
          "EmitSIP"
          "SIP"
          "EmitPOP3"
          "POP3"
          "EmitSMTP"
          "SMTP"
          "EmitLPR"
          "LPR"
          "EmitRouter"
          "Router"
          "EmitTimezone"
          "Timezone"
          "SendOption"
          "SendVendorOption"
          "BindToInterface"
          "RelayTarget"
          "RelayAgentCircuitId"
          "RelayAgentRemoteId"
          "BootServerAddress"
          "BootServerName"
          "BootFilename"
        ])
        (assertInt "PoolOffset")
        (assertMinimum "PoolOffset" 0)
        (assertInt "PoolSize")
        (assertMinimum "PoolSize" 0)
        (assertValueOneOf "EmitDNS" boolValues)
        (assertValueOneOf "EmitNTP" boolValues)
        (assertValueOneOf "EmitSIP" boolValues)
        (assertValueOneOf "EmitPOP3" boolValues)
        (assertValueOneOf "EmitSMTP" boolValues)
        (assertValueOneOf "EmitLPR" boolValues)
        (assertValueOneOf "EmitRouter" boolValues)
        (assertValueOneOf "EmitTimezone" boolValues)
        (assertValueOneOf "BindToInterface" boolValues)
      ];

      sectionIPv6SendRA = checkUnitConfig "IPv6SendRA" [
        (assertOnlyFields [
          "Managed"
          "OtherInformation"
          "RouterLifetimeSec"
          "RouterPreference"
          "UplinkInterface"
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

      sectionIPv6PREF64Prefix = checkUnitConfigWithLegacyKey "ipv6PREF64PrefixConfig" "IPv6PREF64Prefix" [
        (assertOnlyFields [
          "Prefix"
          "LifetimeSec"
        ])
        (assertInt "LifetimeSec")
      ];

      sectionIPv6Prefix = checkUnitConfigWithLegacyKey "ipv6PrefixConfig" "IPv6Prefix" [
        (assertOnlyFields [
          "AddressAutoconfiguration"
          "OnLink"
          "Prefix"
          "PreferredLifetimeSec"
          "ValidLifetimeSec"
          "Assign"
          "Token"
        ])
        (assertValueOneOf "AddressAutoconfiguration" boolValues)
        (assertValueOneOf "OnLink" boolValues)
        (assertValueOneOf "Assign" boolValues)
      ];

      sectionIPv6RoutePrefix = checkUnitConfigWithLegacyKey "ipv6RoutePrefixConfig" "IPv6RoutePrefix" [
        (assertOnlyFields [
          "Route"
          "LifetimeSec"
        ])
        (assertHasField "Route")
        (assertInt "LifetimeSec")
      ];

      sectionDHCPServerStaticLease = checkUnitConfigWithLegacyKey "dhcpServerStaticLeaseConfig" "DHCPServerStaticLease" [
        (assertOnlyFields [
          "MACAddress"
          "Address"
        ])
        (assertHasField "MACAddress")
        (assertHasField "Address")
        (assertMacAddress "MACAddress")
      ];

      sectionBridge = checkUnitConfig "Bridge" [
        (assertOnlyFields [
          "UnicastFlood"
          "MulticastFlood"
          "MulticastToUnicast"
          "NeighborSuppression"
          "Learning"
          "HairPin"
          "Isolated"
          "UseBPDU"
          "FastLeave"
          "AllowPortToBeRoot"
          "ProxyARP"
          "ProxyARPWiFi"
          "MulticastRouter"
          "Cost"
          "Priority"
        ])
        (assertValueOneOf "UnicastFlood" boolValues)
        (assertValueOneOf "MulticastFlood" boolValues)
        (assertValueOneOf "MulticastToUnicast" boolValues)
        (assertValueOneOf "NeighborSuppression" boolValues)
        (assertValueOneOf "Learning" boolValues)
        (assertValueOneOf "HairPin" boolValues)
        (assertValueOneOf "Isolated" boolValues)
        (assertValueOneOf "UseBPDU" boolValues)
        (assertValueOneOf "FastLeave" boolValues)
        (assertValueOneOf "AllowPortToBeRoot" boolValues)
        (assertValueOneOf "ProxyARP" boolValues)
        (assertValueOneOf "ProxyARPWiFi" boolValues)
        (assertValueOneOf "MulticastRouter" [ "no" "query" "permanent" "temporary" ])
        (assertInt "Cost")
        (assertRange "Cost" 1 65535)
        (assertInt "Priority")
        (assertRange "Priority" 0 63)
      ];

      sectionBridgeFDB = checkUnitConfigWithLegacyKey "bridgeFDBConfig" "BridgeFDB" [
        (assertOnlyFields [
          "MACAddress"
          "Destination"
          "VLANId"
          "VNI"
          "AssociatedWith"
          "OutgoingInterface"
        ])
        (assertHasField "MACAddress")
        (assertInt "VLANId")
        (assertRange "VLANId" 0 4094)
        (assertInt "VNI")
        (assertRange "VNI" 1 16777215)
        (assertValueOneOf "AssociatedWith" [ "use" "self" "master" "router" ])
      ];

      sectionBridgeMDB = checkUnitConfigWithLegacyKey "bridgeMDBConfig" "BridgeMDB" [
        (assertOnlyFields [
          "MulticastGroupAddress"
          "VLANId"
        ])
        (assertHasField "MulticastGroupAddress")
        (assertInt "VLANId")
        (assertRange "VLANId" 0 4094)
      ];

      sectionLLDP = checkUnitConfig "LLDP" [
        (assertOnlyFields [
          "MUDURL"
        ])
      ];

      sectionCAN = checkUnitConfig "CAN" [
        (assertOnlyFields [
          "BitRate"
          "SamplePoint"
          "TimeQuantaNSec"
          "PropagationSegment"
          "PhaseBufferSegment1"
          "PhaseBufferSegment2"
          "SyncJumpWidth"
          "DataBitRate"
          "DataSamplePoint"
          "DataTimeQuantaNSec"
          "DataPropagationSegment"
          "DataPhaseBufferSegment1"
          "DataPhaseBufferSegment2"
          "DataSyncJumpWidth"
          "FDMode"
          "FDNonISO"
          "RestartSec"
          "Termination"
          "TripleSampling"
          "BusErrorReporting"
          "ListenOnly"
          "Loopback"
          "OneShot"
          "PresumeAck"
          "ClassicDataLengthCode"
        ])
        (assertInt "TimeQuantaNSec" )
        (assertRange "TimeQuantaNSec" 0 4294967295 )
        (assertInt "PropagationSegment" )
        (assertRange "PropagationSegment" 0 4294967295 )
        (assertInt "PhaseBufferSegment1" )
        (assertRange "PhaseBufferSegment1" 0 4294967295 )
        (assertInt "PhaseBufferSegment2" )
        (assertRange "PhaseBufferSegment2" 0 4294967295 )
        (assertInt "SyncJumpWidth" )
        (assertRange "SyncJumpWidth" 0 4294967295 )
        (assertInt "DataTimeQuantaNSec" )
        (assertRange "DataTimeQuantaNSec" 0 4294967295 )
        (assertInt "DataPropagationSegment" )
        (assertRange "DataPropagationSegment" 0 4294967295 )
        (assertInt "DataPhaseBufferSegment1" )
        (assertRange "DataPhaseBufferSegment1" 0 4294967295 )
        (assertInt "DataPhaseBufferSegment2" )
        (assertRange "DataPhaseBufferSegment2" 0 4294967295 )
        (assertInt "DataSyncJumpWidth" )
        (assertRange "DataSyncJumpWidth" 0 4294967295 )
        (assertValueOneOf "FDMode" boolValues)
        (assertValueOneOf "FDNonISO" boolValues)
        (assertValueOneOf "TripleSampling" boolValues)
        (assertValueOneOf "BusErrorReporting" boolValues)
        (assertValueOneOf "ListenOnly" boolValues)
        (assertValueOneOf "Loopback" boolValues)
        (assertValueOneOf "OneShot" boolValues)
        (assertValueOneOf "PresumeAck" boolValues)
        (assertValueOneOf "ClassicDataLengthCode" boolValues)
      ];

      sectionIPoIB = checkUnitConfig "IPoIB" [
        (assertOnlyFields [
          "Mode"
          "IgnoreUserspaceMulticastGroup"
        ])
        (assertValueOneOf "Mode" [ "datagram" "connected" ])
        (assertValueOneOf "IgnoreUserspaceMulticastGroup" boolValues)
      ];

      sectionQDisc = checkUnitConfig "QDisc" [
        (assertOnlyFields [
          "Parent"
          "Handle"
        ])
        (assertValueOneOf "Parent" [ "clsact" "ingress" ])
      ];

      sectionNetworkEmulator = checkUnitConfig "NetworkEmulator" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "DelaySec"
          "DelayJitterSec"
          "PacketLimit"
          "LossRate"
          "DuplicateRate"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 0 4294967294)
      ];

      sectionTokenBucketFilter = checkUnitConfig "TokenBucketFilter" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "LatencySec"
          "LimitBytes"
          "BurstBytes"
          "Rate"
          "MPUBytes"
          "PeakRate"
          "MTUBytes"
        ])
      ];

      sectionPIE = checkUnitConfig "PIE" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 1 4294967294)
      ];

      sectionFlowQueuePIE = checkUnitConfig "FlowQueuePIE" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 1 4294967294)
      ];

      sectionStochasticFairBlue = checkUnitConfig "StochasticFairBlue" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 1 4294967294)
      ];

      sectionStochasticFairnessQueueing = checkUnitConfig "StochasticFairnessQueueing" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PerturbPeriodSec"
        ])
        (assertInt "PerturbPeriodSec")
      ];

      sectionBFIFO = checkUnitConfig "BFIFO" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "LimitBytes"
        ])
      ];

      sectionPFIFO = checkUnitConfig "PFIFO" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 0 4294967294)
      ];

      sectionPFIFOHeadDrop = checkUnitConfig "PFIFOHeadDrop" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 0 4294967294)
      ];

      sectionPFIFOFast = checkUnitConfig "PFIFOFast" [
        (assertOnlyFields [
          "Parent"
          "Handle"
        ])
      ];

      sectionCAKE = checkUnitConfig "CAKE" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "Bandwidth"
          "AutoRateIngress"
          "OverheadBytes"
          "MPUBytes"
          "CompensationMode"
          "UseRawPacketSize"
          "FlowIsolationMode"
          "NAT"
          "PriorityQueueingPreset"
          "FirewallMark"
          "Wash"
          "SplitGSO"
          "AckFilter"
        ])
        (assertValueOneOf "AutoRateIngress" boolValues)
        (assertInt "OverheadBytes")
        (assertRange "OverheadBytes" (-64) 256)
        (assertInt "MPUBytes")
        (assertRange "MPUBytes" 1 256)
        (assertValueOneOf "CompensationMode" [ "none" "atm" "ptm" ])
        (assertValueOneOf "UseRawPacketSize" boolValues)
        (assertValueOneOf "FlowIsolationMode"
          [
            "none"
            "src-host"
            "dst-host"
            "hosts"
            "flows"
            "dual-src-host"
            "dual-dst-host"
            "triple"
          ])
        (assertValueOneOf "NAT" boolValues)
        (assertValueOneOf "PriorityQueueingPreset"
          [
            "besteffort"
            "precedence"
            "diffserv8"
            "diffserv4"
            "diffserv3"
          ])
        (assertInt "FirewallMark")
        (assertRange "FirewallMark" 1 4294967295)
        (assertValueOneOf "Wash" boolValues)
        (assertValueOneOf "SplitGSO" boolValues)
        (assertValueOneOf "AckFilter" (boolValues ++ ["aggressive"]))
      ];

      sectionControlledDelay = checkUnitConfig "ControlledDelay" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
          "TargetSec"
          "IntervalSec"
          "ECN"
          "CEThresholdSec"
        ])
        (assertValueOneOf "ECN" boolValues)
      ];

      sectionDeficitRoundRobinScheduler = checkUnitConfig "DeficitRoundRobinScheduler" [
        (assertOnlyFields [
          "Parent"
          "Handle"
        ])
      ];

      sectionDeficitRoundRobinSchedulerClass = checkUnitConfig "DeficitRoundRobinSchedulerClass" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "QuantumBytes"
        ])
      ];

      sectionEnhancedTransmissionSelection = checkUnitConfig "EnhancedTransmissionSelection" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "Bands"
          "StrictBands"
          "QuantumBytes"
          "PriorityMap"
        ])
        (assertInt "Bands")
        (assertRange "Bands" 1 16)
        (assertInt "StrictBands")
        (assertRange "StrictBands" 1 16)
      ];

      sectionGenericRandomEarlyDetection = checkUnitConfig "GenericRandomEarlyDetection" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "VirtualQueues"
          "DefaultVirtualQueue"
          "GenericRIO"
        ])
        (assertInt "VirtualQueues")
        (assertRange "VirtualQueues" 1 16)
        (assertInt "DefaultVirtualQueue")
        (assertRange "DefaultVirtualQueue" 1 16)
        (assertValueOneOf "GenericRIO" boolValues)
      ];

      sectionFairQueueingControlledDelay = checkUnitConfig "FairQueueingControlledDelay" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
          "MemoryLimitBytes"
          "Flows"
          "TargetSec"
          "IntervalSec"
          "QuantumBytes"
          "ECN"
          "CEThresholdSec"
        ])
        (assertInt "PacketLimit")
        (assertInt "Flows")
        (assertValueOneOf "ECN" boolValues)
      ];

      sectionFairQueueing = checkUnitConfig "FairQueueing" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
          "FlowLimit"
          "QuantumBytes"
          "InitualQuantumBytes"
          "MaximumRate"
          "Buckets"
          "OrphanMask"
          "Pacing"
          "CEThresholdSec"
        ])
        (assertInt "PacketLimit")
        (assertInt "FlowLimit")
        (assertInt "OrphanMask")
        (assertValueOneOf "Pacing" boolValues)
      ];

      sectionTrivialLinkEqualizer = checkUnitConfig "TrivialLinkEqualizer" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "Id"
        ])
      ];

      sectionHierarchyTokenBucket = checkUnitConfig "HierarchyTokenBucket" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "DefaultClass"
          "RateToQuantum"
        ])
        (assertInt "RateToQuantum")
      ];

      sectionHierarchyTokenBucketClass = checkUnitConfig "HierarchyTokenBucketClass" [
        (assertOnlyFields [
          "Parent"
          "ClassId"
          "Priority"
          "QuantumBytes"
          "MTUBytes"
          "OverheadBytes"
          "Rate"
          "CeilRate"
          "BufferBytes"
          "CeilBufferBytes"
        ])
      ];

      sectionHeavyHitterFilter = checkUnitConfig "HeavyHitterFilter" [
        (assertOnlyFields [
          "Parent"
          "Handle"
          "PacketLimit"
        ])
        (assertInt "PacketLimit")
        (assertRange "PacketLimit" 0 4294967294)
      ];

      sectionQuickFairQueueing = checkUnitConfig "QuickFairQueueing" [
        (assertOnlyFields [
          "Parent"
          "Handle"
        ])
      ];

      sectionQuickFairQueueingClass = checkUnitConfig "QuickFairQueueingClass" [
        (assertOnlyFields [
          "Parent"
          "ClassId"
          "Weight"
          "MaxPacketBytes"
        ])
        (assertInt "Weight")
        (assertRange "Weight" 1 1023)
      ];

      sectionBridgeVLAN = checkUnitConfigWithLegacyKey "bridgeVLANConfig" "BridgeVLAN" [
        (assertOnlyFields [
          "VLAN"
          "EgressUntagged"
          "PVID"
        ])
        (assertInt "PVID")
        (assertRange "PVID" 0 4094)
      ];
    };
  };

  commonNetworkOptions = {

    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to manage network configuration using {command}`systemd-network`.

        This also enables {option}`systemd.networkd.enable`.
      '';
    };

    matchConfig = mkOption {
      default = {};
      example = { Name = "eth0"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        `[Match]` section of the unit.  See
        {manpage}`systemd.link(5)`
        {manpage}`systemd.netdev(5)`
        {manpage}`systemd.network(5)`
        for details.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = "Extra configuration append to unit";
    };
  };

  networkdOptions = {
    networkConfig = mkOption {
      default = {};
      example = { SpeedMeter = true; ManageForeignRoutingPolicyRules = false; };
      type = types.addCheck (types.attrsOf unitOption) check.global.sectionNetwork;
      description = ''
        Each attribute in this set specifies an option in the
        `[Network]` section of the networkd config.
        See {manpage}`networkd.conf(5)` for details.
      '';
    };

    dhcpV4Config = mkOption {
      default = {};
      example = { DUIDType = "vendor"; };
      type = types.addCheck (types.attrsOf unitOption) check.global.sectionDHCPv4;
      description = ''
        Each attribute in this set specifies an option in the
        `[DHCPv4]` section of the networkd config.
        See {manpage}`networkd.conf(5)` for details.
      '';
    };

    dhcpV6Config = mkOption {
      default = {};
      example = { DUIDType = "vendor"; };
      type = types.addCheck (types.attrsOf unitOption) check.global.sectionDHCPv6;
      description = ''
        Each attribute in this set specifies an option in the
        `[DHCPv6]` section of the networkd config.
        See {manpage}`networkd.conf(5)` for details.
      '';
    };
  };

  linkOptions = commonNetworkOptions // {
    # overwrite enable option from above
    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable this .link unit. It's handled by udev no matter if {command}`systemd-networkd` is enabled or not
      '';
    };

    linkConfig = mkOption {
      default = {};
      example = { MACAddress = "00:ff:ee:aa:cc:dd"; };
      type = types.addCheck (types.attrsOf unitOption) check.link.sectionLink;
      description = ''
        Each attribute in this set specifies an option in the
        `[Link]` section of the unit.  See
        {manpage}`systemd.link(5)` for details.
      '';
    };

  };

  mkSubsectionType = oldKey: checkF:
    let
      type = types.addCheck (types.attrsOf unitOption) checkF;
    in type // {
      merge = loc: defs:
        let
          final = type.merge loc defs;
        in
        if final?${oldKey}
          then warn
            "Using '${oldKey}' is deprecated! Move all attributes inside one level up and remove it."
            final.${oldKey}
        else
          final;
    };

  netdevOptions = commonNetworkOptions // {

    netdevConfig = mkOption {
      example = { Name = "mybridge"; Kind = "bridge"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionNetdev;
      description = ''
        Each attribute in this set specifies an option in the
        `[Netdev]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    bridgeConfig = mkOption {
      default = {};
      example = { STP = true; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionBridge;
      description = ''
        Each attribute in this set specifies an option in the
        `[Bridge]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    vlanConfig = mkOption {
      default = {};
      example = { Id = 4; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVLAN;
      description = ''
        Each attribute in this set specifies an option in the
        `[VLAN]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    ipvlanConfig = mkOption {
      default = {};
      example = { Mode = "L2"; Flags = "private"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionIPVLAN;
      description = ''
        Each attribute in this set specifies an option in the `[IPVLAN]` section of the unit.
        See {manpage}`systemd.netdev(5)` for details.
      '';
    };

    ipvtapConfig = mkOption {
      default = {};
      example = { Mode = "L3"; Flags = "vepa"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionIPVTAP;
      description = ''
        Each attribute in this set specifies an option in the `[IPVTAP]` section of the unit.
        See {manpage}`systemd.netdev(5)` for details.
      '';
    };

    macvlanConfig = mkOption {
      default = {};
      example = { Mode = "private"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionMACVLAN;
      description = ''
        Each attribute in this set specifies an option in the
        `[MACVLAN]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    vxlanConfig = mkOption {
      default = {};
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVXLAN;
      description = ''
        Each attribute in this set specifies an option in the
        `[VXLAN]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    tunnelConfig = mkOption {
      default = {};
      example = { Remote = "192.168.1.1"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTunnel;
      description = ''
        Each attribute in this set specifies an option in the
        `[Tunnel]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    fooOverUDPConfig = mkOption {
      default = { };
      example = { Port = 9001; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionFooOverUDP;
      description = ''
        Each attribute in this set specifies an option in the
        `[FooOverUDP]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    peerConfig = mkOption {
      default = {};
      example = { Name = "veth2"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionPeer;
      description = ''
        Each attribute in this set specifies an option in the
        `[Peer]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    tunConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTun;
      description = ''
        Each attribute in this set specifies an option in the
        `[Tun]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    tapConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionTap;
      description = ''
        Each attribute in this set specifies an option in the
        `[Tap]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    l2tpConfig = mkOption {
      default = {};
      example = {
        TunnelId = 10;
        PeerTunnelId = 12;
        Local = "static";
        Remote = "192.168.30.101";
        EncapsulationType = "ip";
      };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionL2TP;
      description = ''
        Each attribute in this set specifies an option in the
        `[L2TP]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    l2tpSessions = mkOption {
      default = [];
      example = [ {
        SessionId = 25;
        PeerSessionId = 26;
        Name = "l2tp-sess";
      }];
      type = types.listOf (mkSubsectionType "l2tpSessionConfig" check.netdev.sectionL2TPSession);
      description = ''
        Each item in this array specifies an option in the
        `[L2TPSession]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    wireguardConfig = mkOption {
      default = {};
      example = {
        PrivateKeyFile = "/etc/wireguard/secret.key";
        ListenPort = 51820;
        FirewallMark = 42;
      };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionWireGuard;
      description = ''
        Each attribute in this set specifies an option in the
        `[WireGuard]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
        Use `PrivateKeyFile` instead of
        `PrivateKey`: the nix store is
        world-readable.
      '';
    };

    wireguardPeers = mkOption {
      default = [];
      example = [ {
        Endpoint = "192.168.1.1:51820";
        PublicKey = "27s0OvaBBdHoJYkH9osZpjpgSOVNw+RaKfboT/Sfq0g=";
        PresharedKeyFile = "/etc/wireguard/psk.key";
        AllowedIPs = [ "10.0.0.1/32" ];
        PersistentKeepalive = 15;
      } ];
      type = types.listOf (mkSubsectionType "wireguardPeerConfig" check.netdev.sectionWireGuardPeer);
      description = ''
        Each item in this array specifies an option in the
        `[WireGuardPeer]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
        Use `PresharedKeyFile` instead of
        `PresharedKey`: the nix store is
        world-readable.
      '';
    };

    bondConfig = mkOption {
      default = {};
      example = { Mode = "802.3ad"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionBond;
      description = ''
        Each attribute in this set specifies an option in the
        `[Bond]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    xfrmConfig = mkOption {
      default = {};
      example = { InterfaceId = 1; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionXfrm;
      description = ''
        Each attribute in this set specifies an option in the
        `[Xfrm]` section of the unit.  See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

    vrfConfig = mkOption {
      default = {};
      example = { Table = 2342; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionVRF;
      description = ''
        Each attribute in this set specifies an option in the
        `[VRF]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
        A detailed explanation about how VRFs work can be found in the
        [kernel docs](https://www.kernel.org/doc/Documentation/networking/vrf.txt).
      '';
    };

    wlanConfig = mkOption {
      default = {};
      example = { PhysicalDevice = 0; Type = "station"; };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionWLAN;
      description = ''
        Each attribute in this set specifies an option in the `[WLAN]` section of the unit.
        See {manpage}`systemd.netdev(5)` for details.
      '';
    };

    batmanAdvancedConfig = mkOption {
      default = {};
      example = {
        GatewayMode = "server";
        RoutingAlgorithm = "batman-v";
      };
      type = types.addCheck (types.attrsOf unitOption) check.netdev.sectionBatmanAdvanced;
      description = ''
        Each attribute in this set specifies an option in the
        `[BatmanAdvanced]` section of the unit. See
        {manpage}`systemd.netdev(5)` for details.
      '';
    };

  };

  networkOptions = commonNetworkOptions // {

    linkConfig = mkOption {
      default = {};
      example = { Unmanaged = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionLink;
      description = ''
        Each attribute in this set specifies an option in the
        `[Link]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    networkConfig = mkOption {
      default = {};
      example = { Description = "My Network"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionNetwork;
      description = ''
        Each attribute in this set specifies an option in the
        `[Network]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
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
        `[DHCPv4]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    dhcpV6Config = mkOption {
      default = {};
      example = { UseDNS = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPv6;
      description = ''
        Each attribute in this set specifies an option in the
        `[DHCPv6]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    dhcpV6PrefixDelegationConfig = mkOption {
      visible = false;
      apply = _: throw "The option `systemd.network.networks.<name>.dhcpV6PrefixDelegationConfig` has been renamed to `systemd.network.networks.<name>.dhcpPrefixDelegationConfig`.";
    };

    dhcpPrefixDelegationConfig = mkOption {
      default = {};
      example = { SubnetId = "auto"; Announce = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPPrefixDelegation;
      description = ''
        Each attribute in this set specifies an option in the
        `[DHCPPrefixDelegation]` section of the unit. See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    ipv6AcceptRAConfig = mkOption {
      default = {};
      example = { UseDNS = true; DHCPv6Client = "always"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionIPv6AcceptRA;
      description = ''
        Each attribute in this set specifies an option in the
        `[IPv6AcceptRA]` section of the unit. See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    dhcpServerConfig = mkOption {
      default = {};
      example = { PoolOffset = 50; EmitDNS = false; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDHCPServer;
      description = ''
        Each attribute in this set specifies an option in the
        `[DHCPServer]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    # systemd.network.networks.*.ipv6PrefixDelegationConfig has been deprecated
    # in 247 in favor of systemd.network.networks.*.ipv6SendRAConfig.
    ipv6PrefixDelegationConfig = mkOption {
      visible = false;
      apply = _: throw "The option `systemd.network.networks.*.ipv6PrefixDelegationConfig` has been replaced by `systemd.network.networks.*.ipv6SendRAConfig`.";
    };

    ipv6SendRAConfig = mkOption {
      default = {};
      example = { EmitDNS = true; Managed = true; OtherInformation = true; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionIPv6SendRA;
      description = ''
        Each attribute in this set specifies an option in the
        `[IPv6SendRA]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    ipv6PREF64Prefixes = mkOption {
      default = [];
      example = [ { Prefix = "64:ff9b::/96"; } ];
      type = types.listOf (mkSubsectionType "ipv6PREF64PrefixConfig" check.network.sectionIPv6PREF64Prefix);
      description = ''
        A list of IPv6PREF64Prefix sections to be added to the unit. See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    dhcpServerStaticLeases = mkOption {
      default = [];
      example = [ { MACAddress = "65:43:4a:5b:d8:5f"; Address = "192.168.1.42"; } ];
      type = types.listOf (mkSubsectionType "dhcpServerStaticLeaseConfig" check.network.sectionDHCPServerStaticLease);
      description = ''
        A list of DHCPServerStaticLease sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    ipv6Prefixes = mkOption {
      default = [];
      example = [ { AddressAutoconfiguration = true; OnLink = true; } ];
      type = types.listOf (mkSubsectionType "ipv6PrefixConfig" check.network.sectionIPv6Prefix);
      description = ''
        A list of ipv6Prefix sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    ipv6RoutePrefixes = mkOption {
      default = [];
      example = [ { Route = "fd00::/64"; LifetimeSec = 3600; } ];
      type = types.listOf (mkSubsectionType "ipv6RoutePrefixConfig" check.network.sectionIPv6RoutePrefix);
      description = ''
        A list of ipv6RoutePrefix sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    bridgeConfig = mkOption {
      default = {};
      example = { MulticastFlood = false; Cost = 20; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionBridge;
      description = ''
        Each attribute in this set specifies an option in the
        `[Bridge]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    bridgeFDBs = mkOption {
      default = [];
      example = [ { MACAddress = "90:e2:ba:43:fc:71"; Destination = "192.168.100.4"; VNI = 3600; } ];
      type = types.listOf (mkSubsectionType "bridgeFDBConfig" check.network.sectionBridgeFDB);
      description = ''
        A list of BridgeFDB sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    bridgeMDBs = mkOption {
      default = [];
      example = [ { MulticastGroupAddress = "ff02::1:2:3:4"; VLANId = 10; } ];
      type = types.listOf (mkSubsectionType "bridgeMDBConfig" check.network.sectionBridgeMDB);
      description = ''
        A list of BridgeMDB sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    lldpConfig = mkOption {
      default = {};
      example = { MUDURL = "https://things.example.org/product_abc123/v5"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionLLDP;
      description = ''
        Each attribute in this set specifies an option in the
        `[LLDP]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    canConfig = mkOption {
      default = {};
      example = { };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionCAN;
      description = ''
        Each attribute in this set specifies an option in the
        `[CAN]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    ipoIBConfig = mkOption {
      default = {};
      example = { };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionIPoIB;
      description = ''
        Each attribute in this set specifies an option in the
        `[IPoIB]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    qdiscConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionQDisc;
      description = ''
        Each attribute in this set specifies an option in the
        `[QDisc]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    networkEmulatorConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; DelaySec = "20msec"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionNetworkEmulator;
      description = ''
        Each attribute in this set specifies an option in the
        `[NetworkEmulator]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    tokenBucketFilterConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; Rate = "100k"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionTokenBucketFilter;
      description = ''
        Each attribute in this set specifies an option in the
        `[TokenBucketFilter]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    pieConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PacketLimit = "3847"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionPIE;
      description = ''
        Each attribute in this set specifies an option in the
        `[PIE]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    flowQueuePIEConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PacketLimit = "3847"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionFlowQueuePIE;
      description = ''
        Each attribute in this set specifies an option in the
        `[FlowQueuePIE]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    stochasticFairBlueConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PacketLimit = "3847"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionStochasticFairBlue;
      description = ''
        Each attribute in this set specifies an option in the
        `[StochasticFairBlue]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    stochasticFairnessQueueingConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PerturbPeriodSec = "30"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionStochasticFairnessQueueing;
      description = ''
        Each attribute in this set specifies an option in the
        `[StochasticFairnessQueueing]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    bfifoConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; LimitBytes = "20K"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionBFIFO;
      description = ''
        Each attribute in this set specifies an option in the
        `[BFIFO]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    pfifoConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PacketLimit = "300"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionPFIFO;
      description = ''
        Each attribute in this set specifies an option in the
        `[PFIFO]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    pfifoHeadDropConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; PacketLimit = "300"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionPFIFOHeadDrop;
      description = ''
        Each attribute in this set specifies an option in the
        `[PFIFOHeadDrop]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    pfifoFastConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionPFIFOFast;
      description = ''
        Each attribute in this set specifies an option in the
        `[PFIFOFast]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    cakeConfig = mkOption {
      default = {};
      example = { Bandwidth = "40M"; OverheadBytes = 8; CompensationMode = "ptm"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionCAKE;
      description = ''
        Each attribute in this set specifies an option in the
        `[CAKE]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    controlledDelayConfig = mkOption {
      default = {};
      example = { Parent = "ingress"; TargetSec = "20msec"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionControlledDelay;
      description = ''
        Each attribute in this set specifies an option in the
        `[ControlledDelay]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    deficitRoundRobinSchedulerConfig = mkOption {
      default = {};
      example = { Parent = "root"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDeficitRoundRobinScheduler;
      description = ''
        Each attribute in this set specifies an option in the
        `[DeficitRoundRobinScheduler]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    deficitRoundRobinSchedulerClassConfig = mkOption {
      default = {};
      example = { Parent = "root"; QuantumBytes = "300k"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionDeficitRoundRobinSchedulerClass;
      description = ''
        Each attribute in this set specifies an option in the
        `[DeficitRoundRobinSchedulerClass]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    enhancedTransmissionSelectionConfig = mkOption {
      default = {};
      example = { Parent = "root"; QuantumBytes = "300k"; Bands = 3; PriorityMap = "100 200 300"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionEnhancedTransmissionSelection;
      description = ''
        Each attribute in this set specifies an option in the
        `[EnhancedTransmissionSelection]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    genericRandomEarlyDetectionConfig = mkOption {
      default = {};
      example = { Parent = "root"; VirtualQueues = 5; DefaultVirtualQueue = 3; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionGenericRandomEarlyDetection;
      description = ''
        Each attribute in this set specifies an option in the
        `[GenericRandomEarlyDetection]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    fairQueueingControlledDelayConfig = mkOption {
      default = {};
      example = { Parent = "root"; Flows = 5; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionFairQueueingControlledDelay;
      description = ''
        Each attribute in this set specifies an option in the
        `[FairQueueingControlledDelay]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    fairQueueingConfig = mkOption {
      default = {};
      example = { Parent = "root"; FlowLimit = 5; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionFairQueueing;
      description = ''
        Each attribute in this set specifies an option in the
        `[FairQueueing]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    trivialLinkEqualizerConfig = mkOption {
      default = {};
      example = { Parent = "root"; Id = 0; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionTrivialLinkEqualizer;
      description = ''
        Each attribute in this set specifies an option in the
        `[TrivialLinkEqualizer]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    hierarchyTokenBucketConfig = mkOption {
      default = {};
      example = { Parent = "root"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionHierarchyTokenBucket;
      description = ''
        Each attribute in this set specifies an option in the
        `[HierarchyTokenBucket]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    hierarchyTokenBucketClassConfig = mkOption {
      default = {};
      example = { Parent = "root"; Rate = "10M"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionHierarchyTokenBucketClass;
      description = ''
        Each attribute in this set specifies an option in the
        `[HierarchyTokenBucketClass]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    heavyHitterFilterConfig = mkOption {
      default = {};
      example = { Parent = "root"; PacketLimit = 10000; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionHeavyHitterFilter;
      description = ''
        Each attribute in this set specifies an option in the
        `[HeavyHitterFilter]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    quickFairQueueingConfig = mkOption {
      default = {};
      example = { Parent = "root"; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionQuickFairQueueing;
      description = ''
        Each attribute in this set specifies an option in the
        `[QuickFairQueueing]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    quickFairQueueingConfigClass = mkOption {
      default = {};
      example = { Parent = "root"; Weight = 133; };
      type = types.addCheck (types.attrsOf unitOption) check.network.sectionQuickFairQueueingClass;
      description = ''
        Each attribute in this set specifies an option in the
        `[QuickFairQueueingClass]` section of the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    bridgeVLANs = mkOption {
      default = [];
      example = [ { VLAN = "10-20"; } ];
      type = types.listOf (mkSubsectionType "bridgeVLANConfig" check.network.sectionBridgeVLAN);
      description = ''
        A list of BridgeVLAN sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
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
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    gateway = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of gateways to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    dns = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of dns servers to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    ntp = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of ntp servers to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    bridge = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of bridge interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    bond = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of bond interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    vrf = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vrf interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    vlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vlan interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    macvlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of macvlan interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    macvtap = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of macvtap interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    vxlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vxlan interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    tunnel = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of tunnel interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    xfrm = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of xfrm interfaces to be added to the network section of the
        unit.  See {manpage}`systemd.network(5)` for details.
      '';
    };

    addresses = mkOption {
      default = [ ];
      example = [ { Address = "192.168.0.100/24"; } ];
      type = types.listOf (mkSubsectionType "addressConfig" check.network.sectionAddress);
      description = ''
        A list of address sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    routingPolicyRules = mkOption {
      default = [ ];
      example = [ { Table = 10; IncomingInterface = "eth1"; Family = "both"; } ];
      type = types.listOf (mkSubsectionType "routingPolicyRuleConfig" check.network.sectionRoutingPolicyRule);
      description = ''
        A list of routing policy rules sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
      '';
    };

    routes = mkOption {
      default = [ ];
      example = [ { Gateway = "192.168.0.1"; } ];
      type = types.listOf (mkSubsectionType "routeConfig" check.network.sectionRoute);
      description = ''
        A list of route sections to be added to the unit.  See
        {manpage}`systemd.network(5)` for details.
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

  networkdConfig = { config, ... }: {
    options = {
      routeTables = mkOption {
        default = {};
        example = { foo = 27; };
        type = with types; attrsOf int;
        description = ''
          Defines route table names as an attrset of name to number.
          See {manpage}`networkd.conf(5)` for details.
        '';
      };

      addRouteTablesToIPRoute2 = mkOption {
        default = true;
        example = false;
        type = types.bool;
        description = ''
          If true and routeTables are set, then the specified route tables
          will also be installed into /etc/iproute2/rt_tables.
        '';
      };
    };

    config = {
      networkConfig = optionalAttrs (config.routeTables != { }) {
        RouteTable = mapAttrsToList
          (name: number: "${name}:${toString number}")
          config.routeTables;
      };
    };
  };

  renderConfig = def:
    { text = ''
        [Network]
        ${attrsToSection def.networkConfig}
      ''
      + optionalString (def.dhcpV4Config != { }) ''
        [DHCPv4]
        ${attrsToSection def.dhcpV4Config}
      ''
      + optionalString (def.dhcpV6Config != { }) ''
        [DHCPv6]
        ${attrsToSection def.dhcpV6Config}
      ''; };

  mkUnitFiles = prefix: cfg: listToAttrs (map (name: {
    name = "${prefix}systemd/network/${name}";
    value.source = "${cfg.units.${name}.unit}/${name}";
  }) (attrNames cfg.units));

  commonOptions = visible: {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable networkd or not.
      '';
    };

    links = mkOption {
      default = {};
      inherit visible;
      type = with types; attrsOf (submodule [ { options = linkOptions; } ]);
      description = "Definition of systemd network links.";
    };

    netdevs = mkOption {
      default = {};
      inherit visible;
      type = with types; attrsOf (submodule [ { options = netdevOptions; } ]);
      description = "Definition of systemd network devices.";
    };

    networks = mkOption {
      default = {};
      inherit visible;
      type = with types; attrsOf (submodule [ { options = networkOptions; } networkConfig ]);
      description = "Definition of systemd networks.";
    };

    config = mkOption {
      default = {};
      inherit visible;
      type = with types; submodule [ { options = networkdOptions; } networkdConfig ];
      description = "Definition of global systemd network config.";
    };

    units = mkOption {
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

    wait-online = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to enable the systemd-networkd-wait-online service.

          systemd-networkd-wait-online can timeout and fail if there are no network interfaces
          available for it to manage. When systemd-networkd is enabled but a different service is
          responsible for managing the system's internet connection (for example, NetworkManager or
          connman are used to manage WiFi connections), this service is unnecessary and can be
          disabled.
        '';
      };
      anyInterface = mkOption {
        description = ''
          Whether to consider the network online when any interface is online, as opposed to all of them.
          This is useful on portable machines with a wired and a wireless interface, for example.

          This is on by default if {option}`networking.useDHCP` is enabled.
        '';
        type = types.bool;
        defaultText = "config.networking.useDHCP";
        default = config.networking.useDHCP;
      };

      ignoredInterfaces = mkOption {
        description = ''
          Network interfaces to be ignored when deciding if the system is online.
        '';
        type = with types; listOf str;
        default = [];
        example = [ "wg0" ];
      };

      timeout = mkOption {
        description = ''
          Time to wait for the network to come online, in seconds. Set to 0 to disable.
        '';
        type = types.ints.unsigned;
        default = 120;
        example = 0;
      };

      extraArgs = mkOption {
        description = ''
          Extra command-line arguments to pass to systemd-networkd-wait-online.
          These also affect per-interface `systemd-network-wait-online@` services.

          See {manpage}`systemd-networkd-wait-online.service(8)` for all available options.
        '';
        type = with types; listOf str;
        default = [];
      };
    };

  };

  commonConfig = config: let
    cfg = config.systemd.network;
    mkUnit = f: def: { inherit (def) enable; text = f def; };
  in mkMerge [

    # .link units are honored by udev, no matter if systemd-networkd is enabled or not.
    {
      systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.link" (mkUnit linkToUnit v)) cfg.links;

      systemd.network.wait-online.extraArgs =
        [ "--timeout=${toString cfg.wait-online.timeout}" ]
        ++ optional cfg.wait-online.anyInterface "--any"
        ++ map (i: "--ignore=${i}") cfg.wait-online.ignoredInterfaces;
    }

    (mkIf config.systemd.network.enable {

      systemd.network.units = mapAttrs' (n: v: nameValuePair "${n}.netdev" (mkUnit netdevToUnit v)) cfg.netdevs
        // mapAttrs' (n: v: nameValuePair "${n}.network" (mkUnit networkToUnit v)) cfg.networks;

      # systemd-networkd is socket-activated by kernel netlink route change
      # messages. It is important to have systemd buffer those on behalf of
      # networkd.
      systemd.sockets.systemd-networkd.wantedBy = [ "sockets.target" ];

      systemd.services.systemd-networkd-wait-online = {
        inherit (cfg.wait-online) enable;
        wantedBy = [ "network-online.target" ];
        serviceConfig.ExecStart = [
          ""
          "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online ${utils.escapeSystemdExecArgs cfg.wait-online.extraArgs}"
        ];
      };

      systemd.services."systemd-network-wait-online@" = {
        description = "Wait for Network Interface %I to be Configured";
        conflicts = [ "shutdown.target" ];
        requisite = [ "systemd-networkd.service" ];
        after = [ "systemd-networkd.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online -i %I ${utils.escapeSystemdExecArgs cfg.wait-online.extraArgs}";
        };
      };

    })
  ];

  stage2Config = let
    cfg = config.systemd.network;
    unitFiles = mkUnitFiles "" cfg;
  in mkMerge [
    (commonConfig config)

    { environment.etc = unitFiles; }

    (mkIf config.systemd.network.enable {

      users.users.systemd-network.group = "systemd-network";

      systemd.additionalUpstreamSystemUnits = [
        "systemd-networkd-wait-online.service"
        "systemd-networkd.service"
        "systemd-networkd.socket"
        "systemd-networkd-persistent-storage.service"
      ];

      environment.etc."systemd/networkd.conf" = renderConfig cfg.config;

      systemd.services.systemd-networkd = let
        isReloadableUnitFileName = unitFileName: strings.hasSuffix ".network" unitFileName;
        reloadableUnitFiles = attrsets.filterAttrs (k: v: isReloadableUnitFileName k) unitFiles;
        nonReloadableUnitFiles = attrsets.filterAttrs (k: v: !isReloadableUnitFileName k) unitFiles;
        unitFileSources = unitFiles: map (x: x.source) (attrValues unitFiles);
      in {
        wantedBy = [ "multi-user.target" ];
        reloadTriggers = unitFileSources reloadableUnitFiles;
        restartTriggers = unitFileSources nonReloadableUnitFiles ++ [
          config.environment.etc."systemd/networkd.conf".source
        ];
        aliases = [ "dbus-org.freedesktop.network1.service" ];
      };

      networking.iproute2 = mkIf (cfg.config.addRouteTablesToIPRoute2 && cfg.config.routeTables != { }) {
        enable = mkDefault true;
        rttablesExtraConfig = ''

          # Extra tables defined in NixOS systemd.networkd.config.routeTables.
          ${concatStringsSep "\n" (mapAttrsToList (name: number: "${toString number} ${name}") cfg.config.routeTables)}
        '';
      };

      services.resolved.enable = mkDefault true;

    })
  ];

  stage1Options = {
    options.boot.initrd.systemd.network.networks = mkOption {
      type = with types; attrsOf (submodule {
        # Default in initrd is dhcp-on-stop, which is correct if flushBeforeStage2 = false
        config = mkIf config.boot.initrd.network.flushBeforeStage2 {
          networkConfig.KeepConfiguration = mkDefault false;
        };
      });
    };
  };

  stage1Config = let
    cfg = config.boot.initrd.systemd.network;
  in mkMerge [
    (commonConfig config.boot.initrd)

    {
      systemd.network.enable = mkDefault config.boot.initrd.network.enable;
      systemd.contents = mkUnitFiles "/etc/" cfg;

      # Networkd link files are used early by udev to set up interfaces early.
      # This must be done in stage 1 to avoid race conditions between udev and
      # network daemons.
      systemd.network.units = lib.filterAttrs (n: _: hasSuffix ".link" n) config.systemd.network.units;
      systemd.storePaths = ["${config.boot.initrd.systemd.package}/lib/systemd/network/99-default.link"];
    }

    (mkIf cfg.enable {

      # For networkctl
      systemd.dbus.enable = mkDefault true;

      systemd.additionalUpstreamUnits = [
        "systemd-networkd-wait-online.service"
        "systemd-networkd.service"
        "systemd-networkd.socket"
        "systemd-network-generator.service"
        "network-online.target"
        "network-pre.target"
        "network.target"
        "nss-lookup.target"
        "nss-user-lookup.target"
        "remote-fs-pre.target"
        "remote-fs.target"
      ];
      systemd.users.systemd-network = {};
      systemd.groups.systemd-network = {};

      systemd.contents."/etc/systemd/networkd.conf" = renderConfig cfg.config;

      systemd.services.systemd-networkd = {
        wantedBy = [ "initrd.target" ];
      };
      systemd.sockets.systemd-networkd = {
        wantedBy = [ "initrd.target" ];
      };

      systemd.services.systemd-network-generator.wantedBy = [ "sysinit.target" ];

      systemd.storePaths = [
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-networkd"
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-networkd-wait-online"
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-network-generator"
      ];
      kernelModules = [ "af_packet" ];

    })
  ];

in

{
  imports = [ stage1Options ];

  options = {
    systemd.network = commonOptions true;
    boot.initrd.systemd.network = commonOptions "shallow";
  };

  config = mkMerge [
    stage2Config
    (mkIf config.boot.initrd.systemd.enable {
      assertions = [{
        assertion = !config.boot.initrd.network.udhcpc.enable && config.boot.initrd.network.udhcpc.extraArgs == [];
        message = ''
          systemd stage 1 networking does not support 'boot.initrd.network.udhcpc'. Configure
          DHCP with 'networking.*' options or with 'boot.initrd.systemd.network' options.
        '';
      }];

      boot.initrd = stage1Config;
    })
  ];
}
