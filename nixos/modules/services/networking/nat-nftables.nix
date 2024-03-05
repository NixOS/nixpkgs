{ config, lib, ... }:

with lib;

let
  cfg = config.networking.nat;

  mkDest = externalIP:
    if externalIP == null
    then "masquerade"
    else "snat ${externalIP}";
  dest = mkDest cfg.externalIP;
  destIPv6 = mkDest cfg.externalIPv6;

  toNftSet = list: concatStringsSep ", " list;
  toNftRange = ports: replaceStrings [ ":" ] [ "-" ] (toString ports);

  ifaceSet = toNftSet (map (x: ''"${x}"'') cfg.internalInterfaces);
  ipSet = toNftSet cfg.internalIPs;
  ipv6Set = toNftSet cfg.internalIPv6s;
  oifExpr = optionalString (cfg.externalInterface != null) ''oifname "${cfg.externalInterface}"'';

  # Whether given IP (plus optional port) is an IPv6.
  isIPv6 = ip: length (lib.splitString ":" ip) > 2;

  splitIPPorts = IPPorts:
    let
      matchIP = if isIPv6 IPPorts then "[[]([0-9a-fA-F:]+)[]]" else "([0-9.]+)";
      m = builtins.match "${matchIP}:([0-9-]+)" IPPorts;
    in
    {
      IP = if m == null then throw "bad ip:ports `${IPPorts}'" else elemAt m 0;
      ports = if m == null then throw "bad ip:ports `${IPPorts}'" else elemAt m 1;
    };

  mkTable = { ipVer, dest, ipSet, forwardPorts, dmzHost }:
    let
      # nftables maps for port forward
      # l4proto . dport : addr . port
      fwdMap = toNftSet (map
        (fwd:
          with (splitIPPorts fwd.destination);
          "${fwd.proto} . ${toNftRange fwd.sourcePort} : ${IP} . ${ports}"
        )
        forwardPorts);

      # nftables maps for port forward loopback dnat
      # daddr . l4proto . dport : addr . port
      fwdLoopDnatMap = toNftSet (concatMap
        (fwd: map
          (loopbackip:
            with (splitIPPorts fwd.destination);
            "${loopbackip} . ${fwd.proto} . ${toNftRange fwd.sourcePort} : ${IP} . ${ports}"
          )
          fwd.loopbackIPs)
        forwardPorts);

      # nftables set for port forward loopback snat
      # daddr . l4proto . dport
      fwdLoopSnatSet = toNftSet (map
        (fwd:
          with (splitIPPorts fwd.destination);
          "${IP} . ${fwd.proto} . ${ports}"
        )
        forwardPorts);
    in
    ''
      chain pre {
        type nat hook prerouting priority dstnat;

        ${optionalString (fwdMap != "") ''
          iifname "${cfg.externalInterface}" meta l4proto { tcp, udp } dnat meta l4proto . th dport map { ${fwdMap} } comment "port forward"
        ''}

        ${optionalString (fwdLoopDnatMap != "") ''
          meta l4proto { tcp, udp } dnat ${ipVer} daddr . meta l4proto . th dport map { ${fwdLoopDnatMap} } comment "port forward loopback from other hosts behind NAT"
        ''}

        ${optionalString (dmzHost != null) ''
          iifname "${cfg.externalInterface}" dnat ${dmzHost} comment "dmz"
        ''}
      }

      chain post {
        type nat hook postrouting priority srcnat;

        ${optionalString (ifaceSet != "") ''
          iifname { ${ifaceSet} } ${oifExpr} ${dest} comment "from internal interfaces"
        ''}
        ${optionalString (ipSet != "") ''
          ${ipVer} saddr { ${ipSet} } ${oifExpr} ${dest} comment "from internal IPs"
        ''}

        ${optionalString (fwdLoopSnatSet != "") ''
          iifname != "${cfg.externalInterface}" ${ipVer} daddr . meta l4proto . th dport { ${fwdLoopSnatSet} } masquerade comment "port forward loopback snat"
        ''}
      }

      chain out {
        type nat hook output priority mangle;

        ${optionalString (fwdLoopDnatMap != "") ''
          meta l4proto { tcp, udp } dnat ${ipVer} daddr . meta l4proto . th dport map { ${fwdLoopDnatMap} } comment "port forward loopback from the host itself"
        ''}
      }
    '';

in

{

  config = mkIf (config.networking.nftables.enable && cfg.enable) {

    assertions = [
      {
        assertion = cfg.extraCommands == "";
        message = "extraCommands is incompatible with the nftables based nat module: ${cfg.extraCommands}";
      }
      {
        assertion = cfg.extraStopCommands == "";
        message = "extraStopCommands is incompatible with the nftables based nat module: ${cfg.extraStopCommands}";
      }
      {
        assertion = config.networking.nftables.rulesetFile == null;
        message = "networking.nftables.rulesetFile conflicts with the nat module";
      }
    ];

    networking.nftables.tables = {
      "nixos-nat" = {
        family = "ip";
        content = mkTable {
          ipVer = "ip";
          inherit dest ipSet;
          forwardPorts = filter (x: !(isIPv6 x.destination)) cfg.forwardPorts;
          inherit (cfg) dmzHost;
        };
      };
      "nixos-nat6" = mkIf cfg.enableIPv6 {
        family = "ip6";
        name = "nixos-nat";
        content = mkTable {
          ipVer = "ip6";
          dest = destIPv6;
          ipSet = ipv6Set;
          forwardPorts = filter (x: isIPv6 x.destination) cfg.forwardPorts;
          dmzHost = null;
        };
      };
    };

    networking.firewall.extraForwardRules = optionalString config.networking.firewall.filterForward ''
      ${optionalString (ifaceSet != "") ''
        iifname { ${ifaceSet} } ${oifExpr} accept comment "from internal interfaces"
      ''}
      ${optionalString (ipSet != "") ''
        ip saddr { ${ipSet} } ${oifExpr} accept comment "from internal IPs"
      ''}
      ${optionalString (ipv6Set != "") ''
        ip6 saddr { ${ipv6Set} } ${oifExpr} accept comment "from internal IPv6s"
      ''}
    '';

  };
}
