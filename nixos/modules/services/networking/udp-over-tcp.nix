{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    escapeShellArgs
    filterAttrs
    getExe'
    last
    literalExpression
    maintainers
    mapAttrs'
    mkOption
    mkPackageOption
    optionals
    splitString
    toInt
    types
    ;

  cfg = config.services.udp-over-tcp;

  commonOptions = {
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open the appropriate ports in the firewall.
      '';
    };

    # Options and descriptions as indicated by `tcp2udp --help` and `udp2tcp --help`.
    forward = mkOption {
      type = types.str;
      description = ''
        The IP and port to forward all traffic to.
      '';
    };
    recvBufferSize = mkOption {
      type = types.nullOr types.ints.positive;
      description = ''
        If given, sets the SO_RCVBUF option on the TCP socket to the given number of bytes.
        Changes the size of the operating system's receive buffer associated with the socket.
      '';
      default = null;
    };
    sendBufferSize = mkOption {
      type = types.nullOr types.ints.positive;
      description = ''
        If given, sets the SO_SNDBUF option on the TCP socket to the given number of bytes.
        Changes the size of the operating system's send buffer associated with the socket.
      '';
      default = null;
    };
    recvTimeout = mkOption {
      type = types.nullOr types.ints.positive;
      description = ''
        An application timeout on receiving data from the TCP socket.
      '';
      default = null;
    };
    fwmark = mkOption {
      type = types.nullOr types.ints.u32;
      description = ''
        If given, sets the SO_MARK option on the TCP socket.
      '';
      default = null;
    };
    nodelay = mkOption {
      type = types.bool;
      description = ''
        Enables TCP_NODELAY on the TCP socket.
      '';
      default = false;
    };
  };
  tcp2udpSubmodule = {
    options = commonOptions // {
      threads = mkOption {
        type = types.nullOr types.ints.positive;
        description = ''
          Sets the number of worker threads to use.
          The default value is the number of cores available to the system.
        '';
        default = null;
      };
      bind = mkOption {
        type = types.nullOr types.str;
        description = ''
          Which local IP to bind the UDP socket to.
        '';
        default = null;
      };
    };
  };
  udp2tcpSubmodule = {
    options = commonOptions;
  };

  configToService = type: buildCmdline: listen: conf: {
    name = "${type}-${listen}";
    value = {
      description = "${type} tunnel from ${listen} to ${conf.forward}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;

      serviceConfig = {
        Type = "exec";
        ExecStart = "${getExe' cfg.package type} " + escapeShellArgs (buildCmdline listen conf);

        DynamicUser = true;
        User = "udp-over-tcp";

        # CAP_NET_BIND_SERVICE in case we are binding to ports < 1024, CAP_NET_ADMIN only covers addresses.
        # CAP_NET_ADMIN for setting SO_MARK on the socket.
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
        ];

        Restart = "on-failure";
        RestartSec = 10;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "077";
      };
    };
  };

  buildCommonCmdline =
    listen: conf:
    optionals (conf.recvBufferSize != null) [
      "--recv-buffer"
      conf.recvBufferSize
    ]
    ++ optionals (conf.sendBufferSize != null) [
      "--send-buffer"
      conf.sendBufferSize
    ]
    ++ optionals (conf.recvTimeout != null) [
      "--tcp-recv-timeout"
      conf.recvTimeout
    ]
    ++ optionals (conf.fwmark != null) [
      "--fwmark"
      conf.fwmark
    ]
    ++ optionals conf.nodelay [
      "--nodelay"
    ];
  buildTcp2udpCmdline =
    listen: conf:
    [
      "--tcp-listen"
      listen
      "--udp-forward"
      conf.forward
    ]
    ++ optionals (conf.threads != null) [
      "--threads"
      conf.threads
    ]
    ++ optionals (conf.bind != null) [
      "--udp-bind"
      conf.bind
    ]
    ++ buildCommonCmdline listen conf;
  buildUdp2tcpCmdline =
    listen: conf:
    [
      "--udp-listen"
      listen
      "--tcp-forward"
      conf.forward
    ]
    ++ buildCommonCmdline listen conf;

  getFirewallPorts =
    instances:
    map (e: toInt (last (splitString ":" e))) (
      attrNames (filterAttrs (_: e: e.openFirewall) instances)
    );
in
{
  options.services.udp-over-tcp = {
    package = mkPackageOption pkgs "udp-over-tcp" { };
    tcp2udp = mkOption {
      type = types.attrsOf (types.submodule tcp2udpSubmodule);
      example = literalExpression ''
        {
          "0.0.0.0:443" = {
            forward = "127.0.0.1:51820";
            openFirewall = true;
          };
          "0.0.0.0:444" = {
            threads = 2;
            forward = "127.0.0.1:51821";
            bind = "127.0.0.1";
            recvBufferSize = 16384;
            sendBufferSize = 16384;
            recvTimeout = 10;
            fwmark = 1337;
            nodelay = true;
          };
        }
      '';
      description = ''
        Mapping of TCP listening ports to UDP forwarding ports or configurations.
      '';
      default = { };
    };
    udp2tcp = mkOption {
      type = types.attrsOf (types.submodule udp2tcpSubmodule);
      example = literalExpression ''
        {
          "0.0.0.0:51820" = {
            forward = "10.0.0.1:443";
            openFirewall = true;
          };
          "0.0.0.0:51821" = {
            forward = "10.0.0.1:444";
            recvBufferSize = 16384;
            sendBufferSize = 16384;
            recvTimeout = 10;
            fwmark = 1337;
            nodelay = true;
          };
        }
      '';
      description = ''
        Mapping of UDP listening ports to TCP forwarding ports or configurations.
      '';
      default = { };
    };
  };

  config = {
    systemd.services =
      (mapAttrs' (configToService "tcp2udp" buildTcp2udpCmdline) cfg.tcp2udp)
      // (mapAttrs' (configToService "udp2tcp" buildUdp2tcpCmdline) cfg.udp2tcp);

    networking.firewall.allowedTCPPorts = getFirewallPorts cfg.tcp2udp;
    networking.firewall.allowedUDPPorts = getFirewallPorts cfg.udp2tcp;
  };

  meta.maintainers = with maintainers; [ timschumi ];
}
