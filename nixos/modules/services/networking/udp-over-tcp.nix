{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.udp-over-tcp;

  # Options and descriptions as indicated by `tcp2udp --help` and `udp2tcp --help`.
  commonOptions = {
    forward = lib.mkOption {
      type = lib.types.str;
      description = ''
        The IP and port to forward all traffic to.
      '';
    };
    recvBufferSize = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = ''
        If given, sets the SO_RCVBUF option on the TCP socket to the given number of bytes.
        Changes the size of the operating system's receive buffer associated with the socket.
      '';
      default = null;
    };
    sendBufferSize = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = ''
        If given, sets the SO_SNDBUF option on the TCP socket to the given number of bytes.
        Changes the size of the operating system's send buffer associated with the socket.
      '';
      default = null;
    };
    recvTimeout = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = ''
        An application timeout on receiving data from the TCP socket.
      '';
      default = null;
    };
    fwmark = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = ''
        If given, sets the SO_MARK option on the TCP socket.
      '';
      default = null;
    };
    nodelay = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enables TCP_NODELAY on the TCP socket.
      '';
      default = false;
    };
  };
  tcp2udpSubmodule = {
    options = commonOptions // {
      threads = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        description = ''
          Sets the number of worker threads to use.
          The default value is the number of cores available to the system.
        '';
        default = null;
      };
      bind = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
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
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/${type} " + lib.escapeShellArgs (buildCmdline listen conf);
      };
    };
  };

  buildCommonCmdline =
    listen: conf:
    lib.optionals (conf.recvBufferSize != null) [
      "--recv-buffer"
      conf.recvBufferSize
    ]
    ++ lib.optionals (conf.sendBufferSize != null) [
      "--send-buffer"
      conf.sendBufferSize
    ]
    ++ lib.optionals (conf.recvTimeout != null) [
      "--tcp-recv-timeout"
      conf.recvTimeout
    ]
    ++ lib.optionals (conf.fwmark != null) [
      "--fwmark"
      conf.fwmark
    ]
    ++ lib.optionals conf.nodelay [
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
    ++ lib.optionals (conf.threads != null) [
      "--threads"
      conf.threads
    ]
    ++ lib.optionals (conf.bind != null) [
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
in
{
  options.services.udp-over-tcp = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.udp-over-tcp;
      defaultText = lib.literalExpression "pkgs.udp-over-tcp";
      description = "udp-over-tcp package to use";
    };
    tcp2udp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule tcp2udpSubmodule);
      example = lib.literalExpression ''
        {
          "0.0.0.0:443" = {
            forward = "127.0.0.1:51820";
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
    udp2tcp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule udp2tcpSubmodule);
      example = lib.literalExpression ''
        {
          "0.0.0.0:51820" = {
            forward = "10.0.0.1:443";
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
      (lib.attrsets.mapAttrs' (configToService "tcp2udp" buildTcp2udpCmdline) cfg.tcp2udp)
      // (lib.attrsets.mapAttrs' (configToService "udp2tcp" buildUdp2tcpCmdline) cfg.udp2tcp);
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
