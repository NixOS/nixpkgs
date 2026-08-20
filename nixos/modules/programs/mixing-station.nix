{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.mixing-station;

  isIPv6 = lib.hasInfix ":";
  groups4 = lib.filter (group: !isIPv6 group) cfg.multicastGroups;
  groups6 = lib.filter isIPv6 cfg.multicastGroups;

  nftSet = items: "{ ${lib.concatStringsSep ", " items} }";
  udpSportSet = nftSet (map toString cfg.mixerUdpPorts);
  tcpDportSet = nftSet (map toString cfg.listenTcpPorts);
  ipv4GroupSet = nftSet groups4;
  ipv6GroupSet = nftSet groups6;

  # `null` stands for "match on any interface".
  interfaces = if cfg.firewallInterfaces == [ ] then [ null ] else cfg.firewallInterfaces;
  perInterface = mkRules: lib.concatStringsSep "\n" (lib.concatMap mkRules interfaces);

  nftRules = perInterface (
    iface:
    let
      inIface = lib.optionalString (iface != null) ''iifname "${iface}" '';
    in
    lib.optional (cfg.mixerUdpPorts != [ ]) "${inIface}udp sport ${udpSportSet} accept"
    ++ lib.optional (cfg.listenTcpPorts != [ ]) "${inIface}tcp dport ${tcpDportSet} accept"
    ++ lib.optional (groups4 != [ ]) "${inIface}meta l4proto udp ip daddr ${ipv4GroupSet} accept"
    ++ lib.optional (groups6 != [ ]) "${inIface}meta l4proto udp ip6 daddr ${ipv6GroupSet} accept"
  );

  iptablesRules = perInterface (
    iface:
    let
      inIface = lib.optionalString (iface != null) "-i ${iface} ";
      accept = binary: match: "${binary} -A nixos-fw ${inIface}${match} -j nixos-fw-accept";
    in
    map (port: accept "ip46tables" "-p udp --sport ${toString port}") cfg.mixerUdpPorts
    ++ map (port: accept "ip46tables" "-p tcp --dport ${toString port}") cfg.listenTcpPorts
    ++ map (group: accept "iptables -w" "-p udp -d ${group}") groups4
    ++ lib.optionals config.networking.enableIPv6 (
      map (group: accept "ip6tables -w" "-p udp -d ${group}") groups6
    )
  );
in
{
  options.programs.mixing-station = {
    enable = lib.mkEnableOption "Mixing Station, a remote control app for digital audio mixers";

    package = lib.mkPackageOption pkgs "mixing-station" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to accept the inbound traffic Mixing Station depends on.

        Answers to a connection the app opened itself are already accepted by
        connection tracking. This option covers the traffic that is not:
        discovery (the app broadcasts a request and the mixer answers from its
        own service port to a local port the app picked at random), multicast
        metering, and mixers that connect back to the app instead of accepting
        a connection from it.

        Set {option}`programs.mixing-station.firewallInterfaces` to confine
        these rules to the network the mixer is on. Mixing Station's own REST
        and OSC API ports are not covered; open those with
        {option}`networking.firewall.allowedTCPPorts` and
        {option}`networking.firewall.allowedUDPPorts`.
      '';
    };

    firewallInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "enp3s0" ];
      description = ''
        Interfaces the rules added by
        {option}`programs.mixing-station.openFirewall` are restricted to. The
        empty list applies them to every interface.
      '';
    };

    mixerUdpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [
        2222 # Behringer Wing
        2223 # Behringer Wing
        3804 # HiQNet (Soundcraft Si/Vi)
        5353 # mDNS
        8000 # Soundcraft Ui and other OSC based devices
        10023 # Behringer X32/M32
        10024 # Behringer XAir, Midas MR
        47809 # PreSonus Universal Control discovery
        50240 # Yamaha metering
        50272 # Yamaha metering
        50368 # Yamaha metering
      ];
      description = ''
        UDP ports the mixers themselves listen on.

        These are matched as the *source* port of inbound packets. Mixing
        Station binds its own local port dynamically, so a rule on the
        destination port could not describe this traffic.
      '';
    };

    listenTcpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [
        3804 # HiQNet: the mixer connects to the app, not the other way round
      ];
      description = ''
        TCP ports on this host that mixers connect back to.
      '';
    };

    multicastGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "224.0.0.251" # mDNS
        "ff02::fb" # mDNS
        "239.192.0.164" # Yamaha metering
      ];
      description = ''
        Multicast groups Mixing Station joins. Inbound UDP addressed to these
        groups is accepted on any port, because the app binds a dynamic local
        port for them as well.
      '';
    };

    openSnitchRule = lib.mkOption {
      type = lib.types.bool;
      default = config.services.opensnitch.enable;
      defaultText = lib.literalExpression "config.services.opensnitch.enable";
      description = ''
        Whether to add an OpenSnitch rule that permits every outbound
        connection made by Mixing Station.

        Without it OpenSnitch asks about each connection, which is impractical
        here: the destination port depends on the mixer, discovery uses
        broadcasts, and the app keeps opening new flows while it runs. The rule
        matches on the store path of
        {option}`programs.mixing-station.package`, so it does not cover other
        Java programs.

        Note that OpenSnitch only filters outbound connections. Inbound traffic
        is handled by {option}`programs.mixing-station.openFirewall`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.optional cfg.openSnitchRule {
      assertion = config.services.opensnitch.enable;
      message = "programs.mixing-station.openSnitchRule requires services.opensnitch.enable.";
    };

    environment.systemPackages = [ cfg.package ];

    services.opensnitch.rules = lib.mkIf cfg.openSnitchRule {
      mixing-station = {
        name = "mixing-station";
        description = "Allow all outbound traffic of Mixing Station";
        enabled = true;
        # Wins over broader deny rules.
        precedence = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "regexp";
          sensitive = false;
          operand = "process.command";
          data = lib.escapeRegex "${cfg.package}/";
        };
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      extraCommands = lib.optionalString (!config.networking.nftables.enable) iptablesRules;
      extraInputRules = lib.optionalString config.networking.nftables.enable nftRules;
    };
  };

  meta.maintainers = with lib.maintainers; [ korny666 ];
}
