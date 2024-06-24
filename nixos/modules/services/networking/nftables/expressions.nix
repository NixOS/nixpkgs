{lib, ...}: let
  inherit (lib) concatStringsSep filter flip foldl id length mapAttrs mapAttrsToList mkMerge mkOption optional pipe;
  inherit (lib.types) attrsOf enum int listOf nonEmptyListOf nullOr oneOf str submodule;
  inherit (import ./lib.nix lib) flatMap flatMapAttrsToList formatList;
  inherit (import ./types.nix lib) arp_op bitmask boolean cgroupv2 ct_dir ct_id ct_label ct_state ct_status dccp_pkttype devgroup dscp ecn ether_addr ether_type exprElemType fib_addrtype gid icmp_type icmpv6_type iface_index iface_type ifname igmp_type inet_proto inet_service ip_addr ipv4_addr ipv6_addr l4proto mark nf_proto pkt_type realm tc_handle tcp_flag time u1 u3 u4 u8 u12 u16 u20 u32 u64 uid;

  fromParams = desc: let
    constructor =
      if length desc <= 3
      then keyword: description: type: {inherit keyword description type;}
      else keyword: description: type: extraOptions: {inherit keyword description type extraOptions;};
  in
    foldl id constructor desc;

  fromTable = foldl (acc: a: let
    attrs = fromParams a;
    attrs' = removeAttrs attrs ["keyword"];
    row = {"${attrs.keyword}" = attrs';};
  in
    acc // row) {};

  dropNulls = filter (v: v != null);
  map' = f: v:
    if v == null
    then null
    else f v;
  prepend = what: s: "${what}${s}";
  prepend' = what: map' (prepend what);
  words = concatStringsSep " ";
  words' = flip pipe [dropNulls words];

  withIpFamily = {
    ipFamily = mkOption {
      description = "IP family";
      example = "ip6";
      type = enum ["ip" "ip6"];
    };
    formatter = self: config: prefix: keyword: "${prefix} ${config.ipFamily} ${keyword}";
  };

  metaExpressions = fromTable [
    ["length" "length of the packet in bytes" u32]
    ["nfproto" "real hook protocol family, useful only in inet table" u32]
    ["l4proto" "layer 4 protocol, skips ipv6 extension headers" l4proto]
    ["protocol" "EtherType protocol value" ether_type]
    ["priority" "TC packet priority" tc_handle]
    ["mark" "packet mark" mark]
    ["iif" "input interface index" iface_index]
    ["iifname" "input interface name" ifname]
    ["iiftype" "input interface type" iface_type]
    ["oif" "output interface index" iface_index]
    ["oifname" "output interface name" ifname]
    ["oiftype" "output interface hardware type" iface_type]
    ["sdif" "slave device input interface index" iface_index]
    ["sdifname" "slave device interface name" ifname]
    ["skuid" "UID associated with originating socket" uid]
    ["skgid" "GID associated with originating socket" gid]
    ["rtclassid" "routing realm" realm]
    ["ibrname" "input bridge interface name" ifname]
    ["obrname" "output bridge interface name" ifname]
    ["pkttype" "packet type" pkt_type]
    ["cpu" "cpu number processing the packet" u32]
    ["iifgroup" "incoming device group" devgroup]
    ["oifgroup" "outgoing device group" devgroup]
    ["cgroup" "control group id" u32]
    ["random" "pseudo-random number" u32]
    ["ipsec" "true if packet was ipsec encrypted" boolean]
    ["iifkind" "input interface kind" exprElemType]
    ["oifkind" "output interface kind" exprElemType]
    ["time" "absolute time of packet reception" (oneOf [u32 str])]
    ["day" "day of week" (oneOf [u8 str])]
    ["hour" "hour of day" str]
  ];

  socketExpressions = fromTable [
    ["transparent" "value of the IP_TRANSPARENT socket option in the found socket" boolean]
    ["mark" "value of the socket mark (SOL_SOCKET, SO_MARK)" mark]
    ["wildcard" "indicates whether the socket is wildcard-bound (e.g. 0.0.0.0 or ::0)" boolean]
    ["cgroupv2" "cgroup version 2 for this socket (path from /sys/fs/cgroup)" cgroupv2]
  ];

  withTtl = {
    ttl = mkOption {
      default = null;
      description = "Do TTL checks on the packet to determine the operating system.";
      type = nullOr (enum ["loose" "skip"]);
    };
    formatter = self: config: prefix: keyword:
      words' [prefix (prepend' "ttl " config.ttl) keyword];
  };

  osfExpressions = fromTable [
    ["version" "operating system version" exprElemType withTtl]
    ["name" "operating system name, or \"unknown\" for OS signatures that the expression could not detect" str withTtl]
  ];

  # missing: nested lookup thing
  fibExpressions = fromTable [
    ["oif" "output interface index" u32]
    ["oifname" "output interface name" str]
    ["type" "address type" fib_addrtype]
  ];

  routingExpressions = fromTable [
    ["classid" "routing realm" realm withIpFamily]
    ["nexthop" "routing nexthop" ip_addr withIpFamily]
    ["mtu" "TCP maximum segment size of route" u16 withIpFamily]
    ["ipsec" "route via ipsec tunnel or transport" boolean withIpFamily]
  ];

  withIpsecParams = {
    direction = mkOption {
      description = "Whether to examine inbound or outbound policies";
      type = enum ["in" "out"];
    };

    spnum = mkOption {
      default = 0;
      description = "Match specific state in the chain";
      type = int;
    };

    formatter = self: config: prefix: keyword:
      words' [prefix config.direction (prepend' "spnum " (toString config.spnum)) keyword];
  };
  withIpsecParamsAndIpFamily =
    withIpsecParams
    // withIpFamily
    // {
      formatter = self: config: prefix: keyword:
        words' [prefix config.direction (prepend' "spnum " (toString config.spnum)) config.ipFamily keyword];
    };
  ipsecExpressions = fromTable [
    ["reqid" "request ID" u32 withIpsecParams]
    ["spi" "Security Parameter Index" u32 withIpsecParams]
    ["saddr" "source address of the tunnel" ip_addr withIpsecParamsAndIpFamily]
    ["daddr" "destination address of the tunnel" ip_addr withIpsecParamsAndIpFamily]
  ];

  etherExpressions = fromTable [
    ["daddr" "destination MAC address" ether_addr]
    ["saddr" "source MAC address" ether_addr]
    ["type" "EtherType" ether_type]
  ];

  vlanExpressions = fromTable [
    ["id" "VLAN ID (VID)" u12]
    ["dei" "Drop Eligible Indicator" u1]
    ["pcp" "priority code point" u3]
    ["type" "EtherType" ether_type]
  ];

  arpExpressions = fromTable [
    ["htype" "ARP hardware type" u16]
    ["ptype" "EtherType" ether_type]
    ["hlen" "hardware address len" u8]
    ["plen" "protocol address len" u8]
    ["operation" "operation" arp_op]
    ["saddr ether" "ethernet sender address" ether_addr]
    ["daddr ether" "ethernet target address" ether_addr]
    ["saddr ip" "IPv4 sender address" ipv4_addr]
    ["daddr ip" "IPv4 target address" ipv4_addr]
  ];

  ipv4Expressions = fromTable [
    ["version" "IP header version (4)" u4]
    ["hdrlength" "IP header length including options" u4]
    ["dscp" "Differentiated Services Code Point" dscp]
    ["ecn" "Explicit Congestion Notification" ecn]
    ["length" "total packet length" u16]
    ["id" "IP ID" u16]
    ["frag-off" "Fragment offset" u16]
    ["ttl" "time to live" u8]
    ["protocol" "upper layer protocol" inet_proto]
    ["checksum" "IP header checksum" u16]
    ["saddr" "source address" ipv4_addr]
    ["daddr" "destination address" ipv4_addr]
  ];

  icmpExpressions = fromTable [
    ["type" "ICMP type field" icmp_type]
    ["code" "ICMP code field" u8]
    ["checksum" "ICMP checksum field" u16]
    ["id" "ID of echo request/response" u16]
    ["sequence" "sequence number of echo request/response" u16]
    ["gateway" "gateway of redirects" u32]
    ["mtu" "MTU of path MTU discovery" u16]
  ];

  igmpExpressions = fromTable [
    ["type" "IGMP type field" igmp_type]
    ["mrt" "IGMP maximum response type field" u8]
    ["checksum" "IGMP checksum field" u16]
    ["group" "group address" u32]
  ];

  ipv6Expressions = fromTable [
    ["version" "IP header version (6)" u4]
    ["dscp" "Differentiated Services Code Point" dscp]
    ["ecn" "Explicit Congestion Notification" ecn]
    ["flowlabel" "flow label" u20]
    ["length" "payload length" u16]
    ["nexthdr" "nexthdr protocol" inet_proto]
    ["hoplimit" "hop limit" u8]
    ["saddr" "source address" ipv6_addr]
    ["daddr" "destination address" ipv6_addr]
  ];

  icmpv6Expressions = fromTable [
    ["type" "ICMPv6 type field" icmpv6_type]
    ["code" "ICMPv6 code field" u8]
    ["checksum" "ICMPv6 checksum field" u16]
    ["parameter-problem" "pointer to problem" u32]
    ["packet-too-big" "oversized MTU" u32]
    ["id" "ID of echo request/response" u16]
    ["sequence" "sequence number of echo request/response" u16]
    ["max-delay" "maximum response delay of MLD queries" u16]
  ];

  tcpExpressions = fromTable [
    ["sport" "source port" inet_service]
    ["dport" "destination port" inet_service]
    ["sequence" "sequence number" u32]
    ["ackseq" "acknowledgement number" u32]
    ["doff" "data offset" u4]
    ["reserved" "reserved area" u4]
    ["flags" "TCP flags" tcp_flag]
    ["window" "window" u16]
    ["checksum" "checksum" u16]
    ["urgptr" "urgent pointer" u16]
  ];

  udpExpressions = fromTable [
    ["sport" "source port" inet_service]
    ["dport" "destination port" inet_service]
    ["length" "total packet length" u16]
    ["checksum" "checksum" u16]
  ];

  udpliteExpressions = fromTable [
    ["sport" "source port" inet_service]
    ["dport" "destination port" inet_service]
    ["checksum" "checksum" u16]
  ];

  sctpExpressions = fromTable [
    ["sport" "source port" inet_service]
    ["dport" "destination port" inet_service]
    ["vtag" "verification tag" u32]
    ["checksum" "checksum" u32]
    # missing: chunk
  ];

  dccpExpressions = fromTable [
    ["sport" "source port" inet_service]
    ["dport" "destination port" inet_service]
    ["type" "packet type" dccp_pkttype]
  ];

  ahExpressions = fromTable [
    ["nexthdr" "next header protocol" inet_proto]
    ["hdrlength" "AH header length" u8]
    ["reserved" "reserved area" u16]
    ["spi" "Security Parameter Index" u32]
    ["sequence" "sequence number" u32]
  ];

  espExpressions = fromTable [
    ["spi" "Security Parameter Index" u32]
    ["sequence" "sequence number" u32]
  ];

  ipcompExpressions = fromTable [
    ["nexthdr" "next header protocol" inet_proto]
    ["flags" "flags" bitmask]
    ["cpi" "Compression Parameter Index" u16]
  ];

  ctDirection = enum ["original" "reply"];
  maybeDirection = {
    direction = mkOption {
      default = null;
      description = "Flow direction";
      type = nullOr ctDirection;
    };
    formatter = self: config: prefix: keyword:
      words' [prefix config.direction keyword];
  };
  withDirection = {
    direction = mkOption {
      description = "Flow direction";
      type = ctDirection;
    };
    formatter = self: config: prefix: keyword: "${prefix} ${config.direction} ${keyword}";
  };
  withDirectionAndIpFamily =
    withDirection
    // withIpFamily
    // {
      formatter = self: config: prefix: keyword: "${prefix} ${config.direction} ${config.ipFamily} ${keyword}";
    };

  ctExpressions = fromTable [
    ["state" "state of the connection" ct_state]
    ["direction" "direction of the packet relative to the connection" ct_dir]
    ["status" "status of the connection" ct_status]
    ["mark" "connection mark" mark]
    ["expiration" "connection expiration time" time]
    ["helper" "helper associated with the connection" str]
    ["label" "connection tracking label bit or symbolic name defined in connlabel.conf in the nftables include path" ct_label]
    ["l3proto" "layer 3 protocol of the connection" nf_proto maybeDirection]
    ["saddr" "source address of the connection for the given direction" ip_addr withDirectionAndIpFamily]
    ["daddr" "destination address of the connection for the given direction" ip_addr withDirectionAndIpFamily]
    ["protocol" "layer 4 protocol of the connection for the given direction" inet_proto]
    ["proto-src" "layer 4 protocol source for the given direction" u16 withDirection]
    ["proto-dst" "layer 4 protocol destination for the given direction" u16 withDirection]
    ["packets" "packet count seen in the given direction or sum of original and reply" u64 maybeDirection]
    ["bytes" "byte count seen, see description for packets keyword" u64 maybeDirection]
    ["avgpkt" "average bytes per packet, see description for `packets` keyword" u64 maybeDirection]
    ["zone" "conntrack zone" u16 maybeDirection]
    ["count" "number of current connections" u32]
    ["id" "connection id" ct_id]
  ];

  allExpressions = {
    meta = metaExpressions;
    socket = socketExpressions;
    osf = osfExpressions;
    fib = fibExpressions;
    ipsec = ipsecExpressions;
    rt = routingExpressions;

    ether = etherExpressions;
    vlan = vlanExpressions;
    arp = arpExpressions;
    ip = ipv4Expressions;
    icmp = icmpExpressions;
    igmp = igmpExpressions;
    ip6 = ipv6Expressions;
    icmpv6 = icmpv6Expressions;
    tcp = tcpExpressions;
    udp = udpExpressions;
    udplite = udpliteExpressions;
    sctp = sctpExpressions;
    dccp = dccpExpressions;
    ah = ahExpressions;
    esp = espExpressions;
    ipcomp = ipcompExpressions;
    ct = ctExpressions;

    # missing: numgen, hash, raw, extension header
  };

  mkExprType = desc:
    if !desc ? extraOptions
    then listOf desc.type
    else
      listOf (submodule {
        options =
          removeAttrs desc.extraOptions ["formatter"]
          // {
            match = mkOption {
              default = [];
              description = "Values to match";
              type = listOf desc.type;
            };
          };
      });

  mkExpressionsGroup = mapAttrs (_: desc:
    mkOption {
      default = [];
      description = "Match ${desc.description}";
      type = mkExprType desc;
    });

  formatCustomExpression = config: prefix: keyword: desc:
    flatMap (config: let
      formatted = desc.extraOptions.formatter desc config prefix keyword;
      match = config.match;
    in
      optional (match != []) {"${formatted}" = match;})
    config;

  formatSimpleExpression = config: prefix: keyword: desc: let
    formatted = "${prefix} ${keyword}";
    match = config;
  in
    optional (match != []) {"${formatted}" = match;};

  formatExpression = config: prefix: keyword: desc: let
    config' = config."${prefix}"."${keyword}";
  in
    if desc ? extraOptions
    then formatCustomExpression config' prefix keyword desc
    else formatSimpleExpression config' prefix keyword desc;

  formatExpressionsGroup = config: prefix: descs:
    flatMapAttrsToList (formatExpression config prefix) descs;

  allExpressionsAsOptions = mapAttrs (_: mkExpressionsGroup) allExpressions;

  allExpressionsAsConfig = config: flatMapAttrsToList (formatExpressionsGroup config) allExpressions;

  ruleExt = submodule ({config, ...}: {
    options =
      allExpressionsAsOptions
      // {
        expressions = mkOption {
          default = {};
          description = "nftables expressions part of this rule";
          example = {
            "iifname" = ["eth0" "wlan0"];
            "tcp dport" = [22];
          };
          type = attrsOf (nonEmptyListOf exprElemType);
        };
      };

    config = {
      expressions = mkMerge (allExpressionsAsConfig config);

      components = mapAttrsToList (k: v: "${k} ${formatList v}") config.expressions;
    };
  });

  chainExt = submodule {
    options = {
      rules = mkOption {
        type = listOf ruleExt;
      };
    };
  };

  tableExt = submodule {
    options = {
      chains = mkOption {
        type = attrsOf chainExt;
      };
    };
  };
in {
  options = {
    networking.nftables = {
      tables = mkOption {
        type = attrsOf tableExt;
      };
    };
  };
}
