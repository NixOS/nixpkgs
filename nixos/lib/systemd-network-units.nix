{ lib, systemdUtils }:

let
  inherit (lib)
    concatMapStrings
    concatStringsSep
    flip
    optionalString
    ;

  attrsToSection = systemdUtils.lib.attrsToSection;
  commonMatchText =
    def:
    optionalString (def.matchConfig != { }) ''
      [Match]
      ${attrsToSection def.matchConfig}
    '';
in
{
  linkToUnit =
    def:
    commonMatchText def
    + ''
      [Link]
      ${attrsToSection def.linkConfig}
    ''
    + def.extraConfig;

  netdevToUnit =
    def:
    commonMatchText def
    + ''
      [NetDev]
      ${attrsToSection def.netdevConfig}
    ''
    + optionalString (def.bridgeConfig != { }) ''
      [Bridge]
      ${attrsToSection def.bridgeConfig}
    ''
    + optionalString (def.vlanConfig != { }) ''
      [VLAN]
      ${attrsToSection def.vlanConfig}
    ''
    + optionalString (def.macvlanConfig != { }) ''
      [MACVLAN]
      ${attrsToSection def.macvlanConfig}
    ''
    + optionalString (def.macvtapConfig != { }) ''
      [MACVTAP]
      ${attrsToSection def.macvtapConfig}
    ''
    + optionalString (def.ipvlanConfig != { }) ''
      [IPVLAN]
      ${attrsToSection def.ipvlanConfig}
    ''
    + optionalString (def.ipvtapConfig != { }) ''
      [IPVTAP]
      ${attrsToSection def.ipvtapConfig}
    ''
    + optionalString (def.vxlanConfig != { }) ''
      [VXLAN]
      ${attrsToSection def.vxlanConfig}
    ''
    + optionalString (def.geneveConfig != { }) ''
      [GENEVE]
      ${attrsToSection def.geneveConfig}
    ''
    + optionalString (def.hsrConfig != { }) ''
      [HSR]
      ${attrsToSection def.hsrConfig}
    ''
    + optionalString (def.bareUDPConfig != { }) ''
      [BareUDP]
      ${attrsToSection def.bareUDPConfig}
    ''
    + optionalString (def.l2tpConfig != { }) ''
      [L2TP]
      ${attrsToSection def.l2tpConfig}
    ''
    + flip concatMapStrings def.l2tpSessions (x: ''
      [L2TPSession]
      ${attrsToSection x}
    '')
    + optionalString (def.macsecConfig != { }) ''
      [MACsec]
      ${attrsToSection def.macsecConfig}
    ''
    + optionalString (def.macsecConfig != { }) ''
      [MACsec]
      ${attrsToSection def.macsecConfig}
    ''
    + flip concatMapStrings def.macsecReceiveChannels (x: ''
      [MACsecReceiveChannel]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.macsecTransmitAssociations (x: ''
      [MACsecTransmitAssociation]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.macsecReceiveAssociations (x: ''
      [MACsecReceiveAssociation]
      ${attrsToSection x}
    '')
    + optionalString (def.tunnelConfig != { }) ''
      [Tunnel]
      ${attrsToSection def.tunnelConfig}
    ''
    + optionalString (def.fooOverUDPConfig != { }) ''
      [FooOverUDP]
      ${attrsToSection def.fooOverUDPConfig}
    ''
    + optionalString (def.peerConfig != { }) ''
      [Peer]
      ${attrsToSection def.peerConfig}
    ''
    + optionalString (def.vxcanConfig != { }) ''
      [VXCAN]
      ${attrsToSection def.vxcanConfig}
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
      ${attrsToSection x}
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
    + optionalString (def.batmanAdvancedConfig != { }) ''
      [BatmanAdvanced]
      ${attrsToSection def.batmanAdvancedConfig}
    ''
    + optionalString (def.ipoibConfig != { }) ''
      [IPoIB]
      ${attrsToSection def.ipoibConfig}
    ''
    + optionalString (def.wlanConfig != { }) ''
      [WLAN]
      ${attrsToSection def.wlanConfig}
    ''
    + def.extraConfig;

  networkToUnit =
    def:
    commonMatchText def
    + optionalString (def.linkConfig != { }) ''
      [Link]
      ${attrsToSection def.linkConfig}
    ''
    + optionalString (def.sriovConfig != { }) ''
      [SR-IOV]
      ${attrsToSection def.sriovConfig}
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
    + optionalString (def.macvlan != [ ]) ''
      ${concatStringsSep "\n" (map (s: "MACVLAN=${s}") def.macvlan)}
    ''
    + optionalString (def.ipvlan != [ ]) ''
      ${concatStringsSep "\n" (map (s: "IPVLAN=${s}") def.ipvlan)}
    ''
    + optionalString (def.macvtap != [ ]) ''
      ${concatStringsSep "\n" (map (s: "MACVTAP=${s}") def.macvtap)}
    ''
    + optionalString (def.tunnel != [ ]) ''
      ${concatStringsSep "\n" (map (s: "Tunnel=${s}") def.tunnel)}
    ''
    + optionalString (def.vlan != [ ]) ''
      ${concatStringsSep "\n" (map (s: "VLAN=${s}") def.vlan)}
    ''
    + optionalString (def.vxlan != [ ]) ''
      ${concatStringsSep "\n" (map (s: "VXLAN=${s}") def.vxlan)}
    ''
    + optionalString (def.xfrm != [ ]) ''
      ${concatStringsSep "\n" (map (s: "Xfrm=${s}") def.xfrm)}
    ''
    + "\n"
    + flip concatMapStrings def.addresses (x: ''
      [Address]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.neighbors (x: ''
      [Neighbor]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.ipv6AddressLabels (x: ''
      [IPv6AddressLabel]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.routingPolicyRules (x: ''
      [RoutingPolicyRule]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.nextHops (x: ''
      [NextHop]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.routes (x: ''
      [Route]
      ${attrsToSection x}
    '')
    + optionalString (def.dhcpV4Config != { }) ''
      [DHCPv4]
      ${attrsToSection def.dhcpV4Config}
    ''
    + optionalString (def.dhcpV6Config != { }) ''
      [DHCPv6]
      ${attrsToSection def.dhcpV6Config}
    ''
    + optionalString (def.dhcpPrefixDelegationConfig != { }) ''
      [DHCPPrefixDelegation]
      ${attrsToSection def.dhcpPrefixDelegationConfig}
    ''
    + optionalString (def.ipv6AcceptRAConfig != { }) ''
      [IPv6AcceptRA]
      ${attrsToSection def.ipv6AcceptRAConfig}
    ''
    + optionalString (def.dhcpServerConfig != { }) ''
      [DHCPServer]
      ${attrsToSection def.dhcpServerConfig}
    ''
    + flip concatMapStrings def.dhcpServerStaticLeases (x: ''
      [DHCPServerStaticLease]
      ${attrsToSection x}
    '')
    + optionalString (def.ipv6SendRAConfig != { }) ''
      [IPv6SendRA]
      ${attrsToSection def.ipv6SendRAConfig}
    ''
    + flip concatMapStrings def.ipv6Prefixes (x: ''
      [IPv6Prefix]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.ipv6RoutePrefixes (x: ''
      [IPv6RoutePrefix]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.ipv6PREF64Prefixes (x: ''
      [IPv6PREF64Prefix]
      ${attrsToSection x}
    '')
    + optionalString (def.bridgeConfig != { }) ''
      [Bridge]
      ${attrsToSection def.bridgeConfig}
    ''
    + flip concatMapStrings def.bridgeFDBs (x: ''
      [BridgeFDB]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.bridgeMDBs (x: ''
      [BridgeMDB]
      ${attrsToSection x}
    '')
    + optionalString (def.lldpConfig != { }) ''
      [LLDP]
      ${attrsToSection def.lldpConfig}
    ''
    + optionalString (def.canConfig != { }) ''
      [CAN]
      ${attrsToSection def.canConfig}
    ''
    + optionalString (def.ipoIBConfig != { }) ''
      [IPoIB]
      ${attrsToSection def.ipoIBConfig}
    ''
    + optionalString (def.qdiscConfig != { }) ''
      [QDisc]
      ${attrsToSection def.qdiscConfig}
    ''
    + optionalString (def.networkEmulatorConfig != { }) ''
      [NetworkEmulator]
      ${attrsToSection def.networkEmulatorConfig}
    ''
    + optionalString (def.tokenBucketFilterConfig != { }) ''
      [TokenBucketFilter]
      ${attrsToSection def.tokenBucketFilterConfig}
    ''
    + optionalString (def.pieConfig != { }) ''
      [PIE]
      ${attrsToSection def.pieConfig}
    ''
    + optionalString (def.flowQueuePIEConfig != { }) ''
      [FlowQueuePIE]
      ${attrsToSection def.flowQueuePIEConfig}
    ''
    + optionalString (def.stochasticFairBlueConfig != { }) ''
      [StochasticFairBlue]
      ${attrsToSection def.stochasticFairBlueConfig}
    ''
    + optionalString (def.stochasticFairnessQueueingConfig != { }) ''
      [StochasticFairnessQueueing]
      ${attrsToSection def.stochasticFairnessQueueingConfig}
    ''
    + optionalString (def.bfifoConfig != { }) ''
      [BFIFO]
      ${attrsToSection def.bfifoConfig}
    ''
    + optionalString (def.pfifoConfig != { }) ''
      [PFIFO]
      ${attrsToSection def.pfifoConfig}
    ''
    + optionalString (def.pfifoHeadDropConfig != { }) ''
      [PFIFOHeadDrop]
      ${attrsToSection def.pfifoHeadDropConfig}
    ''
    + optionalString (def.pfifoFastConfig != { }) ''
      [PFIFOFast]
      ${attrsToSection def.pfifoFastConfig}
    ''
    + optionalString (def.cakeConfig != { }) ''
      [CAKE]
      ${attrsToSection def.cakeConfig}
    ''
    + optionalString (def.controlledDelayConfig != { }) ''
      [ControlledDelay]
      ${attrsToSection def.controlledDelayConfig}
    ''
    + optionalString (def.deficitRoundRobinSchedulerConfig != { }) ''
      [DeficitRoundRobinScheduler]
      ${attrsToSection def.deficitRoundRobinSchedulerConfig}
    ''
    + optionalString (def.deficitRoundRobinSchedulerClassConfig != { }) ''
      [DeficitRoundRobinSchedulerClass]
      ${attrsToSection def.deficitRoundRobinSchedulerClassConfig}
    ''
    + optionalString (def.enhancedTransmissionSelectionConfig != { }) ''
      [EnhancedTransmissionSelection]
      ${attrsToSection def.enhancedTransmissionSelectionConfig}
    ''
    + optionalString (def.genericRandomEarlyDetectionConfig != { }) ''
      [GenericRandomEarlyDetection]
      ${attrsToSection def.genericRandomEarlyDetectionConfig}
    ''
    + optionalString (def.fairQueueingControlledDelayConfig != { }) ''
      [FairQueueingControlledDelay]
      ${attrsToSection def.fairQueueingControlledDelayConfig}
    ''
    + optionalString (def.fairQueueingConfig != { }) ''
      [FairQueueing]
      ${attrsToSection def.fairQueueingConfig}
    ''
    + optionalString (def.trivialLinkEqualizerConfig != { }) ''
      [TrivialLinkEqualizer]
      ${attrsToSection def.trivialLinkEqualizerConfig}
    ''
    + optionalString (def.hierarchyTokenBucketConfig != { }) ''
      [HierarchyTokenBucket]
      ${attrsToSection def.hierarchyTokenBucketConfig}
    ''
    + optionalString (def.hierarchyTokenBucketClassConfig != { }) ''
      [HierarchyTokenBucketClass]
      ${attrsToSection def.hierarchyTokenBucketClassConfig}
    ''
    + optionalString (def.classfulMultiQueueingConfig != { }) ''
      [ClassfulMultiQueueing]
      ${attrsToSection def.classfulMultiQueueingConfig}
    ''
    + optionalString (def.bandMultiQueueingConfig != { }) ''
      [BandMultiQueueing]
      ${attrsToSection def.bandMultiQueueingConfig}
    ''
    + optionalString (def.heavyHitterFilterConfig != { }) ''
      [HeavyHitterFilter]
      ${attrsToSection def.heavyHitterFilterConfig}
    ''
    + optionalString (def.quickFairQueueingConfig != { }) ''
      [QuickFairQueueing]
      ${attrsToSection def.quickFairQueueingConfig}
    ''
    + optionalString (def.quickFairQueueingConfigClass != { }) ''
      [QuickFairQueueingClass]
      ${attrsToSection def.quickFairQueueingConfigClass}
    ''
    + optionalString (def.mobileNetworkConfig != { }) ''
      [MobileNetwork]
      ${attrsToSection def.mobileNetworkConfig}
    ''
    + flip concatMapStrings def.bridgeVLANs (x: ''
      [BridgeVLAN]
      ${attrsToSection x}
    '')
    + def.extraConfig;

}
