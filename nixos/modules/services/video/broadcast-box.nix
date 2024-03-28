{ lib, pkgs, config, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    optional;

  cfg = config.services.broadcast-box;

  udpPorts = with cfg; optional (udpMux.port != null) udpMux.port
    ++ optional (udpMux.whep.port != null) udpMux.whep.port
    ++ optional (udpMux.whip.port != null) udpMux.whip.port;

  tcpPorts = with cfg; [ http.port ]
    ++ optional (https.enable && https.redirect) 80
    ++ optional (tcpMux.enable && tcpMux.port != 0) tcpMux.port;
in
{
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.https.enable -> (cfg.https.sslCert != null && cfg.https.sslKey != null);
        message = ''
          `services.broadcast-box.https.enable` requires `https.sslCert` and
          `https.sslKey` to be configured.
        '';
      }
      {
        assertion = (cfg.https.enable && cfg.https.redirect) -> (cfg.http.port == 443);
        message = ''
          `services.broadcast-box.https.redirect` only works if `http.port` is
          443. Either disable redirect or change the port.
        '';
      }
      {
        assertion = lib.allUnique tcpPorts;
        message = ''
          Broadcast Box configuration contains duplicate TCP ports.
        '';
      }
    ];

    systemd.services.broadcast-box = {
      description = "Broadcast Box WebRTC broadcast server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitBurst = 3;
      startLimitIntervalSec = 180;

      environment = with cfg; {
        APP_ENV = "nixos";

        HTTP_ADDRESS = "${http.listenAddress}:${toString http.port}";
        UDP_MUX_PORT = mkIf (udpMux.port != null) (toString udpMux.port);
        UDP_MUX_PORT_WHEP = mkIf (udpMux.whep.port != null) (toString udpMux.whep.port);
        UDP_MUX_PORT_WHIP = mkIf (udpMux.whip.port != null) (toString udpMux.whip.port);
        TCP_MUX_ADDRESS = mkIf tcpMux.enable "${tcpMux.listenAddress}:${toString tcpMux.port}";
        TCP_MUX_FORCE = mkIf (tcpMux.enable && tcpMux.force) "true";
        INTERFACE_FILTER = udpMux.interfaceFilter;

        ENABLE_HTTP_REDIRECT = mkIf (https.enable && https.redirect) "true";
        SSL_CERT = mkIf (https.enable && https.sslCert != null) (toString https.sslCert);
        SSL_KEY = mkIf (https.enable && https.sslKey != null) (toString https.sslKey);

        NETWORK_TEST_ON_START = mkIf cfg.networkTest "true";
        STUN_SERVERS = lib.concatStringsSep "|" cfg.stunServers;
        NAT_1_TO_1_IP = nat.ip;
        INCLUDE_PUBLIC_IP_IN_NAT_1_TO_1_IP = mkIf nat.autoConfigure "true";
        DISABLE_STATUS = mkIf (!statusAPI) "true";
      } // extraEnv;

      serviceConfig =
        let
          priviledgedPort = lib.any (p: p > 0 && p < 1024) (udpPorts ++ tcpPorts);
        in
        {
          ExecStart = "${lib.getExe cfg.package}";
          Restart = "always";
          RestartSec = "10s";

          DynamicUser = true;
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateUsers = !priviledgedPort;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          ProtectProc = "invisible";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProcSubset = "pid";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" ];
          CapabilityBoundingSet = if priviledgedPort then [ "CAP_NET_BIND_SERVICE" ] else "";
          AmbientCapabilities = mkIf priviledgedPort [ "CAP_NET_BIND_SERVICE" ];
          DeviceAllow = "";
          MemoryDenyWriteExecute = true;
          UMask = "0077";
        };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = tcpPorts;
      allowedUDPPorts = udpPorts;
    };
  };

  options.services.broadcast-box = {
    enable = mkEnableOption "Broadcast Box";
    package = lib.mkPackageOption pkgs "broadcast-box" { };

    http.listenAddress = mkOption {
      type = types.str;
      default = "";
      example = "127.0.0.1";
      description = ''
        Address the HTTP server will listen on. By default, listens on all
        available unicast and anycast IP addresses of the local system.
      '';
    };

    http.port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        TCP Port the HTTP server will listen on.
      '';
    };

    https.enable = mkEnableOption ''
      an HTTPS server on address `http.listenAddress` and port `http.port`.

      Enabling this disables the HTTP server.
    '';

    https.redirect = mkEnableOption ''
      an HTTP server on port 80 that redirects HTTP traffic to HTTPS.

      Only works if `http.port` is 443.
    '';

    https.sslCert = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to the SSL certificate.
      '';
    };

    https.sslKey = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to the SSL key.
      '';
    };

    tcpMux.enable = mkEnableOption ''
      serving WebRTC traffic over TCP. Traffic may still be served over UDP
      unless `tcpMux.force` is enabled.
    '';

    tcpMux.listenAddress = mkOption {
      type = types.str;
      default = "";
      example = "127.0.0.1";
      description = ''
        TCP address to serve WebRTC traffic over. By default, listens on all
        available unicast and anycast IP addresses of the local system.

        Requires `tcpMux.enable` to be true.
      '';
    };

    tcpMux.port = mkOption {
      type = types.port;
      default = 0;
      example = 3000;
      description = ''
        TCP port to serve WebRTC traffic over. Must differ from the port used
        in `http.tcp`. By default, selects a random available port.

        Requires `tcpMux.enable` to be true.
      '';
    };

    tcpMux.force = mkEnableOption ''
      serving WebRTC exclusively over TCP. This will disable UDP traffic.

      Requires `tcpMux.enable` to be true.
    '';

    udpMux.port = mkOption {
      type = with types; nullOr port;
      default = null;
      example = 3000;
      description = ''
        UDP port to serve WebRTC traffic over. By default, selects a random
        available UDP port.
      '';
    };

    udpMux.whep.port = mkOption {
      type = with types; nullOr port;
      default = null;
      example = 3000;
      description = ''
        UDP port to exclusively serve WebRTC WHEP traffic over. By default,
        WHEP traffic is sent over `udpMux.port`.
      '';
    };

    udpMux.whip.port = mkOption {
      type = with types; nullOr port;
      default = null;
      example = 3000;
      description = ''
        UDP port to exclusively serve WebRTC WHIP traffic over. By default,
        WHIP traffic is sent over `udpMux.port`.
      '';
    };

    udpMux.interfaceFilter = mkOption {
      type = types.str;
      default = "";
      example = "lo";
      description = ''
        Only use this interface for UDP traffic.
      '';
    };

    openFirewall = mkEnableOption ''
      opening of the utilised ports in the firewall. Any port options that
      result in random port selection will **not** be opened.

      This option does **not** apply an interface filter.
    '';

    networkTest = mkEnableOption ''
      a network test on start-up. Broadcast Box will exit if the test fails.
    '';

    stunServers = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "stun.l.google.com:19302" ];
      description = ''
        List of STUN servers. Useful if Broadcast Box is running behind a NAT.
      '';
    };

    nat.ip = mkOption {
      type = types.str;
      default = "";
      description = ''
        The public IP address to use for 1-to-1 NAT.
      '';
    };

    nat.autoConfigure = mkEnableOption ''
      automatic configuration of `nat.ip` by setting it to your public IP
      address.
    '' // { default = true; };

    statusAPI = mkEnableOption ''
      the status API, which is available at `/api/status`.

      Warning: this will expose your stream keys.
    '';

    extraEnv = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = {
        VARIABLE_NAME = "value";
      };
      description = ''
        Extra environment variables for Broadcast Box.
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ JManch ];
}
