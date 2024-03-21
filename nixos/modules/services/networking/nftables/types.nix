lib: let
  inherit (lib) attrNames;
  inherit (lib.types) enum int ints oneOf str;
  inherit (lib.types.ints) u8 u16 u32 unsigned;
in rec {
  inherit u8 u16 u32;

  exprElemType = oneOf [int str];

  # Assigned to types where it's unknown what they actually are
  placeholder = exprElemType;

  intEnum = baseType: attrs: oneOf [baseType (enum (attrNames attrs))];

  boolean = u1;

  u1 = ints.between 0 1;
  u3 = ints.between 0 7;
  u4 = ints.between 0 15;
  u6 = ints.between 0 63;
  u12 = ints.between 0 4095;
  u20 = ints.between 0 1048575;
  u64 = unsigned;
  bitmask = unsigned;

  # Collected from nft(8) and using `nft describe'.

  ether_addr = str;
  ether_type = intEnum u16 {
    "ip" = 8; # 0x0008
    "arp" = 1544; # 0x0608
    "ip6" = 56710; # 0xdd86
    "8021q" = 129; # 0x0081
    "8021ad" = 43144; # 0xa888
    "vlan" = 129; # 0x0081
  };
  ip_addr = str;
  ipv4_addr = str;
  ipv6_addr = str;

  inet_service = exprElemType;

  tc_handle = placeholder;
  iface_index = u32;
  ifname = str;
  iface_type = intEnum u16 {
    "ether" = 1; # 0x0001
    "ppp" = 512; # 0x0200
    "ipip" = 768; # 0x0300
    "ipip6" = 769; # 0x0301
    "loopback" = 772; # 0x0304
    "sit" = 776; # 0x0308
    "ipgre" = 778; # 0x030a
  };
  uid = u32;
  gid = u32;
  realm = u32;
  pkt_type = intEnum u8 {
    "host" = 0;
    "unicast" = 0;
    "broadcast" = 1;
    "multicast" = 2;
    "other" = 3;
  };
  devgroup = u32;

  cgroupv2 = placeholder;

  fib_addrtype = intEnum u32 {
    "unspec" = 0;
    "unicast" = 1;
    "local" = 2;
    "broadcast" = 3;
    "anycast" = 4;
    "multicast" = 5;
    "blackhole" = 6;
    "unreachable" = 7;
    "prohibit" = 8;
  };

  arp_op = intEnum u16 {
    "request" = 256; # 0x0100
    "reply" = 512; # 0x0200
    "rrequest" = 768; # 0x0300
    "rreply" = 1024; # 0x0400
    "inrequest" = 2048; # 0x0800
    "inreply" = 2304; # 0x0900
    "nak" = 2560; # 0x0a00
  };

  dscp = intEnum u6 {
    "cs0" = 0; # 0x00
    "cs1" = 8; # 0x08
    "cs2" = 16; # 0x10
    "cs3" = 24; # 0x18
    "cs4" = 32; # 0x20
    "cs5" = 40; # 0x28
    "cs6" = 48; # 0x30
    "cs7" = 56; # 0x38
    "df" = 0; # 0x00
    "be" = 0; # 0x00
    "lephb" = 1; # 0x01
    "af11" = 10; # 0x0a
    "af12" = 12; # 0x0c
    "af13" = 14; # 0x0e
    "af21" = 18; # 0x12
    "af22" = 20; # 0x14
    "af23" = 22; # 0x16
    "af31" = 26; # 0x1a
    "af32" = 28; # 0x1c
    "af33" = 30; # 0x1e
    "af41" = 34; # 0x22
    "af42" = 36; # 0x24
    "af43" = 38; #0x26
    "va" = 44; # 0x2c
    "ef" = 46; # 0x2e
  };
  ecn = placeholder;

  icmp_type = intEnum u8 {
    "echo-reply" = 0;
    "destination-unreachable" = 3;
    "source-quench" = 4;
    "redirect" = 5;
    "echo-request" = 8;
    "router-advertisement" = 9;
    "router-solicitation" = 10;
    "time-exceeded" = 11;
    "parameter-problem" = 12;
    "timestamp-request" = 13;
    "timestamp-reply" = 14;
    "info-request" = 15;
    "info-reply" = 16;
    "address-mask-request" = 17;
    "address-mask-reply" = 18;
  };
  icmpv6_type = intEnum u8 {
    "destination-unreachable" = 1;
    "packet-too-big" = 2;
    "time-exceeded" = 3;
    "parameter-problem" = 4;
    "echo-request" = 128;
    "echo-reply" = 129;
    "mld-listener-query" = 130;
    "mld-listener-report" = 131;
    "mld-listener-done" = 132;
    "mld-listener-reduction" = 132;
    "nd-router-solicit" = 133;
    "nd-router-advert" = 134;
    "nd-neighbor-solicit" = 135;
    "nd-neighbor-advert" = 136;
    "nd-redirect" = 137;
    "router-renumbering" = 138;
    "ind-neighbor-solicit" = 141;
    "ind-neighbor-advert" = 142;
    "mld2-listener-report" = 143;
  };

  igmp_type = intEnum u8 {
    "membership-query" = 17;
    "membership-report-v1" = 18;
    "membership-report-v2" = 22;
    "membership-report-v3" = 34;
    "leave-group" = 23;
  };

  tcp_flag = intEnum u8 {
    "fin" = 1; # 0x01
    "syn" = 2; # 0x02
    "rst" = 4; # 0x04
    "psh" = 8; # 0x08
    "ack" = 16; # 0x10
    "urg" = 32; # 0x20
    "ecn" = 64; # 0x40
    "cwr" = 128; # 0x80
  };

  dccp_pkttype = intEnum u4 {
    "request" = 0; # 0x00
    "response" = 1; # 0x01
    "data" = 2; # 0x02
    "ack" = 3; # 0x03
    "dataack" = 4; # 0x04
    "closereq" = 5; # 0x05
    "close" = 6; # 0x06
    "reset" = 7; # 0x07
    "sync" = 8; # 0x08
    "syncack" = 9; # 0x09
  };

  ct_state = intEnum u32 {
    "invalid" = 1; # 0x00000001
    "new" = 8; # 0x00000008
    "established" = 2; # 0x00000002
    "related" = 4; # 0x00000004
    "untracked" = 64; # 0x00000040
  };
  ct_dir = intEnum u8 {
    "original" = 0;
    "reply" = 1;
  };
  ct_status = intEnum u32 {
    "expected" = 1; # 0x00000001
    "seen-reply" = 2; # 0x00000002
    "assured" = 4; # 0x00000004
    "confirmed" = 8; # 0x00000008
    "snat" = 16; # 0x00000010
    "dnat" = 32; # 0x00000020
    "dying" = 512; # 0x00000200
  };
  mark = u32;
  time = int;
  ct_label = int;
  nf_proto = intEnum u8 {
    "ipv4" = 2;
    "ipv6" = 10;
  };
  inet_proto = intEnum u8 {
    "hopopt" = 0;
    "icmp" = 1;
    "igmp" = 2;
    "ggp" = 3;
    "ipv4" = 4;
    "st" = 5;
    "tcp" = 6;
    "cbt" = 7;
    "egp" = 8;
    "igp" = 9;
    "bbn-rcc-mon" = 10;
    "nvp-ii" = 11;
    "pup" = 12;
    "emcon" = 14;
    "xnet" = 15;
    "chaos" = 16;
    "udp" = 17;
    "mux" = 18;
    "dcn-meas" = 19;
    "hmp" = 20;
    "prm" = 21;
    "xns-idp" = 22;
    "trunk-1" = 23;
    "trunk-2" = 24;
    "leaf-1" = 25;
    "leaf-2" = 26;
    "rdp" = 27;
    "irtp" = 28;
    "iso-tp4" = 29;
    "netblt" = 30;
    "mfe-nsp" = 31;
    "merit-inp" = 32;
    "dccp" = 33;
    "3pc" = 34;
    "idpr" = 35;
    "xtp" = 36;
    "ddp" = 37;
    "idpr-cmtp" = 38;
    "tp++" = 39;
    "il" = 40;
    "ipv6" = 41;
    "sdrp" = 42;
    "ipv6-route" = 43;
    "ipv6-frag" = 44;
    "idrp" = 45;
    "rsvp" = 46;
    "gre" = 47;
    "dsr" = 48;
    "bna" = 49;
    "esp" = 50;
    "ah" = 51;
    "i-nlsp" = 52;
    "narp" = 54;
    "min-ipv4" = 55;
    "tlsp" = 56;
    "skip" = 57;
    "ipv6-icmp" = 58;
    "ipv6-nonxt" = 59;
    "ipv6-opts" = 60;
    "cftp" = 62;
    "sat-expak" = 64;
    "kryptolan" = 65;
    "rvd" = 66;
    "ippc" = 67;
    "sat-mon" = 69;
    "visa" = 70;
    "ipcv" = 71;
    "cpnx" = 72;
    "cphb" = 73;
    "wsn" = 74;
    "pvp" = 75;
    "br-sat-mon" = 76;
    "sun-nd" = 77;
    "wb-mon" = 78;
    "wb-expak" = 79;
    "iso-ip" = 80;
    "vmtp" = 81;
    "secure-vmtp" = 82;
    "vines" = 83;
    "iptm" = 84;
    "nsfnet-igp" = 85;
    "dgp" = 86;
    "tcf" = 87;
    "eigrp" = 88;
    "ospfigp" = 89;
    "sprite-rpc" = 90;
    "larp" = 91;
    "mtp" = 92;
    "ax.25" = 93;
    "ipip" = 94;
    "scc-sp" = 96;
    "etherip" = 97;
    "encap" = 98;
    "gmtp" = 100;
    "ifmp" = 101;
    "pnni" = 102;
    "pim" = 103;
    "aris" = 104;
    "scps" = 105;
    "qnx" = 106;
    "a/n" = 107;
    "ipcomp" = 108;
    "snp" = 109;
    "compaq-peer" = 110;
    "ipx-in-ip" = 111;
    "vrrp" = 112;
    "pgm" = 113;
    "l2tp" = 115;
    "ddx" = 116;
    "iatp" = 117;
    "stp" = 118;
    "srp" = 119;
    "uti" = 120;
    "smp" = 121;
    "ptp" = 123;
    "fire" = 125;
    "crtp" = 126;
    "crudp" = 127;
    "sscopmce" = 128;
    "iplt" = 129;
    "sps" = 130;
    "pipe" = 131;
    "sctp" = 132;
    "fc" = 133;
    "rsvp-e2e-ignore" = 134;
    "udplite" = 136;
    "mpls-in-ip" = 137;
    "manet" = 138;
    "hip" = 139;
    "shim6" = 140;
    "wesp" = 141;
    "rohc" = 142;
    "ethernet" = 143;
    "aggfrag" = 144;
    "nsh" = 145;
  };
  ct_id = placeholder;

  l4proto = exprElemType;
}
