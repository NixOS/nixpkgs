{ lib, systemdUtils }:

let
  inherit (lib)
    concatMapStrings
    concatStringsSep
    flip
    lib.optionalString
    ;

  attrsToSection = systemdUtils.lib.attrsToSection;
  commonMatchText =
    def:
    lib.optionalString (def.matchConfig != { }) ''
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
    + lib.optionalString (def.bridgeConfig != { }) ''
      [Bridge]
      ${attrsToSection def.bridgeConfig}
    ''
    + lib.optionalString (def.vlanConfig != { }) ''
      [VLAN]
      ${attrsToSection def.vlanConfig}
    ''
    + lib.optionalString (def.ipvlanConfig != { }) ''
      [IPVLAN]
      ${attrsToSection def.ipvlanConfig}
    ''
    + lib.optionalString (def.ipvtapConfig != { }) ''
      [IPVTAP]
      ${attrsToSection def.ipvtapConfig}
    ''
    + lib.optionalString (def.macvlanConfig != { }) ''
      [MACVLAN]
      ${attrsToSection def.macvlanConfig}
    ''
    + lib.optionalString (def.vxlanConfig != { }) ''
      [VXLAN]
      ${attrsToSection def.vxlanConfig}
    ''
    + lib.optionalString (def.tunnelConfig != { }) ''
      [Tunnel]
      ${attrsToSection def.tunnelConfig}
    ''
    + lib.optionalString (def.fooOverUDPConfig != { }) ''
      [FooOverUDP]
      ${attrsToSection def.fooOverUDPConfig}
    ''
    + lib.optionalString (def.peerConfig != { }) ''
      [Peer]
      ${attrsToSection def.peerConfig}
    ''
    + lib.optionalString (def.tunConfig != { }) ''
      [Tun]
      ${attrsToSection def.tunConfig}
    ''
    + lib.optionalString (def.tapConfig != { }) ''
      [Tap]
      ${attrsToSection def.tapConfig}
    ''
    + lib.optionalString (def.l2tpConfig != { }) ''
      [L2TP]
      ${attrsToSection def.l2tpConfig}
    ''
    + flip concatMapStrings def.l2tpSessions (x: ''
      [L2TPSession]
      ${attrsToSection x}
    '')
    + lib.optionalString (def.wireguardConfig != { }) ''
      [WireGuard]
      ${attrsToSection def.wireguardConfig}
    ''
    + flip concatMapStrings def.wireguardPeers (x: ''
      [WireGuardPeer]
      ${attrsToSection x}
    '')
    + lib.optionalString (def.bondConfig != { }) ''
      [Bond]
      ${attrsToSection def.bondConfig}
    ''
    + lib.optionalString (def.xfrmConfig != { }) ''
      [Xfrm]
      ${attrsToSection def.xfrmConfig}
    ''
    + lib.optionalString (def.vrfConfig != { }) ''
      [VRF]
      ${attrsToSection def.vrfConfig}
    ''
    + lib.optionalString (def.wlanConfig != { }) ''
      [WLAN]
      ${attrsToSection def.wlanConfig}
    ''
    + lib.optionalString (def.batmanAdvancedConfig != { }) ''
      [BatmanAdvanced]
      ${attrsToSection def.batmanAdvancedConfig}
    ''
    + def.extraConfig;

  networkToUnit =
    def:
    commonMatchText def
    + lib.optionalString (def.linkConfig != { }) ''
      [Link]
      ${attrsToSection def.linkConfig}
    ''
    + ''
      [Network]
    ''
    + attrsToSection def.networkConfig
    + lib.optionalString (def.address != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Address=${s}") def.address)}
    ''
    + lib.optionalString (def.gateway != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Gateway=${s}") def.gateway)}
    ''
    + lib.optionalString (def.dns != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "DNS=${s}") def.dns)}
    ''
    + lib.optionalString (def.ntp != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "NTP=${s}") def.ntp)}
    ''
    + lib.optionalString (def.bridge != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Bridge=${s}") def.bridge)}
    ''
    + lib.optionalString (def.bond != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Bond=${s}") def.bond)}
    ''
    + lib.optionalString (def.vrf != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "VRF=${s}") def.vrf)}
    ''
    + lib.optionalString (def.vlan != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "VLAN=${s}") def.vlan)}
    ''
    + lib.optionalString (def.macvlan != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "MACVLAN=${s}") def.macvlan)}
    ''
    + lib.optionalString (def.macvtap != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "MACVTAP=${s}") def.macvtap)}
    ''
    + lib.optionalString (def.vxlan != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "VXLAN=${s}") def.vxlan)}
    ''
    + lib.optionalString (def.tunnel != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Tunnel=${s}") def.tunnel)}
    ''
    + lib.optionalString (def.xfrm != [ ]) ''
      ${lib.concatStringsSep "\n" (map (s: "Xfrm=${s}") def.xfrm)}
    ''
    + "\n"
    + flip concatMapStrings def.addresses (x: ''
      [Address]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.routingPolicyRules (x: ''
      [RoutingPolicyRule]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.routes (x: ''
      [Route]
      ${attrsToSection x}
    '')
    + lib.optionalString (def.dhcpV4Config != { }) ''
      [DHCPv4]
      ${attrsToSection def.dhcpV4Config}
    ''
    + lib.optionalString (def.dhcpV6Config != { }) ''
      [DHCPv6]
      ${attrsToSection def.dhcpV6Config}
    ''
    + lib.optionalString (def.dhcpPrefixDelegationConfig != { }) ''
      [DHCPPrefixDelegation]
      ${attrsToSection def.dhcpPrefixDelegationConfig}
    ''
    + lib.optionalString (def.ipv6AcceptRAConfig != { }) ''
      [IPv6AcceptRA]
      ${attrsToSection def.ipv6AcceptRAConfig}
    ''
    + lib.optionalString (def.dhcpServerConfig != { }) ''
      [DHCPServer]
      ${attrsToSection def.dhcpServerConfig}
    ''
    + lib.optionalString (def.ipv6SendRAConfig != { }) ''
      [IPv6SendRA]
      ${attrsToSection def.ipv6SendRAConfig}
    ''
    + flip concatMapStrings def.ipv6PREF64Prefixes (x: ''
      [IPv6PREF64Prefix]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.ipv6Prefixes (x: ''
      [IPv6Prefix]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.ipv6RoutePrefixes (x: ''
      [IPv6RoutePrefix]
      ${attrsToSection x}
    '')
    + flip concatMapStrings def.dhcpServerStaticLeases (x: ''
      [DHCPServerStaticLease]
      ${attrsToSection x}
    '')
    + lib.optionalString (def.bridgeConfig != { }) ''
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
    + lib.optionalString (def.lldpConfig != { }) ''
      [LLDP]
      ${attrsToSection def.lldpConfig}
    ''
    + lib.optionalString (def.canConfig != { }) ''
      [CAN]
      ${attrsToSection def.canConfig}
    ''
    + lib.optionalString (def.ipoIBConfig != { }) ''
      [IPoIB]
      ${attrsToSection def.ipoIBConfig}
    ''
    + lib.optionalString (def.qdiscConfig != { }) ''
      [QDisc]
      ${attrsToSection def.qdiscConfig}
    ''
    + lib.optionalString (def.networkEmulatorConfig != { }) ''
      [NetworkEmulator]
      ${attrsToSection def.networkEmulatorConfig}
    ''
    + lib.optionalString (def.tokenBucketFilterConfig != { }) ''
      [TokenBucketFilter]
      ${attrsToSection def.tokenBucketFilterConfig}
    ''
    + lib.optionalString (def.pieConfig != { }) ''
      [PIE]
      ${attrsToSection def.pieConfig}
    ''
    + lib.optionalString (def.flowQueuePIEConfig != { }) ''
      [FlowQueuePIE]
      ${attrsToSection def.flowQueuePIEConfig}
    ''
    + lib.optionalString (def.stochasticFairBlueConfig != { }) ''
      [StochasticFairBlue]
      ${attrsToSection def.stochasticFairBlueConfig}
    ''
    + lib.optionalString (def.stochasticFairnessQueueingConfig != { }) ''
      [StochasticFairnessQueueing]
      ${attrsToSection def.stochasticFairnessQueueingConfig}
    ''
    + lib.optionalString (def.bfifoConfig != { }) ''
      [BFIFO]
      ${attrsToSection def.bfifoConfig}
    ''
    + lib.optionalString (def.pfifoConfig != { }) ''
      [PFIFO]
      ${attrsToSection def.pfifoConfig}
    ''
    + lib.optionalString (def.pfifoHeadDropConfig != { }) ''
      [PFIFOHeadDrop]
      ${attrsToSection def.pfifoHeadDropConfig}
    ''
    + lib.optionalString (def.pfifoFastConfig != { }) ''
      [PFIFOFast]
      ${attrsToSection def.pfifoFastConfig}
    ''
    + lib.optionalString (def.cakeConfig != { }) ''
      [CAKE]
      ${attrsToSection def.cakeConfig}
    ''
    + lib.optionalString (def.controlledDelayConfig != { }) ''
      [ControlledDelay]
      ${attrsToSection def.controlledDelayConfig}
    ''
    + lib.optionalString (def.deficitRoundRobinSchedulerConfig != { }) ''
      [DeficitRoundRobinScheduler]
      ${attrsToSection def.deficitRoundRobinSchedulerConfig}
    ''
    + lib.optionalString (def.deficitRoundRobinSchedulerClassConfig != { }) ''
      [DeficitRoundRobinSchedulerClass]
      ${attrsToSection def.deficitRoundRobinSchedulerClassConfig}
    ''
    + lib.optionalString (def.enhancedTransmissionSelectionConfig != { }) ''
      [EnhancedTransmissionSelection]
      ${attrsToSection def.enhancedTransmissionSelectionConfig}
    ''
    + lib.optionalString (def.genericRandomEarlyDetectionConfig != { }) ''
      [GenericRandomEarlyDetection]
      ${attrsToSection def.genericRandomEarlyDetectionConfig}
    ''
    + lib.optionalString (def.fairQueueingControlledDelayConfig != { }) ''
      [FairQueueingControlledDelay]
      ${attrsToSection def.fairQueueingControlledDelayConfig}
    ''
    + lib.optionalString (def.fairQueueingConfig != { }) ''
      [FairQueueing]
      ${attrsToSection def.fairQueueingConfig}
    ''
    + lib.optionalString (def.trivialLinkEqualizerConfig != { }) ''
      [TrivialLinkEqualizer]
      ${attrsToSection def.trivialLinkEqualizerConfig}
    ''
    + lib.optionalString (def.hierarchyTokenBucketConfig != { }) ''
      [HierarchyTokenBucket]
      ${attrsToSection def.hierarchyTokenBucketConfig}
    ''
    + lib.optionalString (def.hierarchyTokenBucketClassConfig != { }) ''
      [HierarchyTokenBucketClass]
      ${attrsToSection def.hierarchyTokenBucketClassConfig}
    ''
    + lib.optionalString (def.heavyHitterFilterConfig != { }) ''
      [HeavyHitterFilter]
      ${attrsToSection def.heavyHitterFilterConfig}
    ''
    + lib.optionalString (def.quickFairQueueingConfig != { }) ''
      [QuickFairQueueing]
      ${attrsToSection def.quickFairQueueingConfig}
    ''
    + lib.optionalString (def.quickFairQueueingConfigClass != { }) ''
      [QuickFairQueueingClass]
      ${attrsToSection def.quickFairQueueingConfigClass}
    ''
    + flip concatMapStrings def.bridgeVLANs (x: ''
      [BridgeVLAN]
      ${attrsToSection x}
    '')
    + def.extraConfig;

}
