{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkPackageOption
    mkOption
    isString
    attrNames
    types
    match
    optional
    boolToString
    toInt
    last
    splitString
    allUnique
    concatStringsSep
    all
    filter
    mapAttrs
    any
    getExe
    maintainers
    ;
  inherit (cfg) settings;
  cfg = config.services.broadcast-box;

  addressToPort = address: toInt (last (splitString ":" address));
  httpPort = cfg.web.port;
  tcpMuxPort = addressToPort settings.TCP_MUX_ADDRESS;
  httpRedirect = settings.ENABLE_HTTP_REDIRECT && (settings.HTTPS_REDIRECT_PORT != null);
  loggingEnabled = settings.LOGGING_ENABLED != false;

  udpPorts =
    optional (settings.UDP_MUX_PORT != null) settings.UDP_MUX_PORT
    ++ optional (settings.UDP_MUX_PORT_WHEP != null) settings.UDP_MUX_PORT_WHEP
    ++ optional (settings.UDP_MUX_PORT_WHIP != null) settings.UDP_MUX_PORT_WHIP;
  tcpPorts = optional (settings.TCP_MUX_ADDRESS != null) tcpMuxPort;
  webPorts = [ httpPort ] ++ optional httpRedirect settings.HTTPS_REDIRECT_PORT;
in
{
  options.services.broadcast-box = {
    enable = mkEnableOption "Broadcast Box";
    package = mkPackageOption pkgs "broadcast-box" { };

    web = {
      host = mkOption {
        type = types.str;
        default = "";
        example = "127.0.0.1";
        description = ''
          Host address the HTTP server listens on. By default the server
          listens on all interfaces.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = ''
          Port the HTTP server listens on.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the HTTP server port and, if enabled, the HTTPS redirect server
        port in the firewall.";
      };
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open WebRTC traffic ports in the firewall. Randomly selected ports
      will not be opened to open the TCP port in the firewall";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );
        options =
          let
            bboxListOption = {
              type = with types; nullOr (either str (listOf str));
              apply = value: if value == null || isString value then value else concatStringsSep "|" value;
            };
          in
          {
            TCP_MUX_ADDRESS = mkOption {
              type = with types; nullOr (strMatching ".*:[0-9]+");
              description = "Address to serve WebRTC traffic over TCP.";
              default = null;
            };

            DISABLE_STATUS = mkOption {
              type = types.bool;
              description = "Disables the status API endpoint.";
              default = true;
            };

            UDP_MUX_PORT = mkOption {
              type = with types; nullOr port;
              description = "Port to multiplex all UDP traffic. Uses random port by default.";
              default = null;
            };

            UDP_MUX_PORT_WHEP = mkOption {
              type = with types; nullOr port;
              description = "Port to multiplex WHEP traffic only.";
              default = null;
            };

            UDP_MUX_PORT_WHIP = mkOption {
              type = with types; nullOr port;
              description = "Port to multiplex WHIP traffic only.";
              default = null;
            };

            ENABLE_HTTP_REDIRECT = mkOption {
              type = types.bool;
              description = "Enables automatic redirection from HTTP to HTTPS.";
              default = false;
            };

            HTTPS_REDIRECT_PORT = mkOption {
              type = with types; nullOr port;
              description = "Port to redirect HTTP traffic to HTTPS when using HTTPS.";
              default = 80;
            };

            LOGGING_ENABLED = mkOption {
              type = with types; nullOr bool;
              description = "Enables logging system.";
              default = null;
            };

            STUN_SERVERS =
              mkOption {
                example = lib.literalExpression ''
                  [
                    "stun.cloudflare.com:3478"
                    "192.168.1.101:3478"
                  ]'';
                description = "List of STUN servers separated by `|`.";
                default = null;
              }
              // bboxListOption;

            NETWORK_TYPES =
              mkOption {
                example = lib.literalExpression ''
                  [
                    "udp4"
                    "udp6"
                  ]'';
                description = "List of network types to use delineated by `|`.";
                default = null;
              }
              // bboxListOption;

            NAT_1_TO_1_IP =
              mkOption {
                default = null;
                description = "Manually specify IPs (like Public IP) to announce, delineated by `|`.";
              }
              // bboxListOption;
          };
      };

      default = { };

      example = {
        DISABLE_STATUS = true;
        INCLUDE_PUBLIC_IP_IN_NAT_1_TO_1_IP = true;
        UDP_MUX_PORT = 3000;
      };

      description = ''
        Attribute set of environment variables.

        <https://github.com/Glimesh/broadcast-box#environment-variables>

        :::{.warning}
        The status API exposes stream keys so {env}`DISABLE_STATUS` is enabled
        by default.
        :::
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(settings ? HTTP_ADDRESS);
        message = ''
          The Broadcast Box `HTTP_ADDRESS` variable should not be used. Instead
          use the `host` and `port` options.
        '';
      }
      {
        assertion = httpRedirect -> settings ? SSL_CERT && settings ? SSL_KEY;
        message = ''
          The Broadcast Box `ENABLE_HTTP_REDIRECT` variable requires `SSL_CERT`
          and `SSL_KEY` to be configured.
        '';
      }
      {
        assertion = httpRedirect -> httpPort == 443;
        message = ''
          Broadcast Box HTTP redirect only works if the HTTP server listen port
          is 443.
        '';
      }
      {
        assertion = allUnique (tcpPorts ++ webPorts);
        message = ''
          Broadcast Box configuration contains duplicate TCP ports.
        '';
      }
      {
        assertion = all (name: (match "[A-Z0-9_]+" name) != null) (attrNames settings);
        message =
          let
            offenders = filter (name: (match "[A-Z0-9_]+" name) == null) (attrNames settings);
          in
          ''
            Broadcast Box `settings` attribute names must be in uppercase snake
            case. Invalid attribute name(s): `${concatStringsSep ", " offenders}`
          '';
      }
    ];

    systemd.services.broadcast-box = {
      description = "Broadcast Box";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitBurst = 3;
      startLimitIntervalSec = 180;

      environment =
        (mapAttrs (
          key: value:
          if (builtins.typeOf value == "bool") then
            # this is the only env variable that checks for "false"
            if key == "LOGGING_ENABLED" then
              boolToString value
            else if !value then
              null
            else
              "true"
          else if (builtins.typeOf value == "int") then
            toString value
          else
            value
        ) cfg.settings)
        // {
          HTTP_ADDRESS = cfg.web.host + ":" + toString cfg.web.port;
        };

      serviceConfig =
        let
          priviledgedPort = any (p: p > 0 && p < 1024) (udpPorts ++ tcpPorts ++ webPorts);
        in
        {
          ExecStart =
            let
              serviceCfg = config.systemd.services.broadcast-box.serviceConfig;
              notDefined = opt: serviceCfg ? ${opt} || serviceCfg.${opt} != null;
              loggingDirectory = lib.optionalString (notDefined "LogsDirectory") "LOGGING_DIRECTORY=$LOGS_DIRECTORY";
              stateDirectory = lib.optionalString (notDefined "StateDirectory") "STREAM_PROFILE_PATH=$STATE_DIRECTORY/profiles";
              cmd = concatStringsSep " " [
                loggingDirectory
                stateDirectory
                (getExe cfg.package)
              ];
            in
            lib.mkAfter "${getExe pkgs.bash} -c '${cmd}'";
          Restart = "always";
          RestartSec = "10s";

          LogsDirectory = mkIf ((!settings ? LOGGING_DIRECTORY) && loggingEnabled) "broadcast-box";
          StateDirectory = mkIf (!settings ? STREAM_PROFILE_PATH) "broadcast-box";

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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          CapabilityBoundingSet = if priviledgedPort then [ "CAP_NET_BIND_SERVICE" ] else "";
          AmbientCapabilities = mkIf priviledgedPort [ "CAP_NET_BIND_SERVICE" ];
          DeviceAllow = "";
          MemoryDenyWriteExecute = true;
          UMask = "0077";
        };
    };

    networking.firewall = {
      allowedTCPPorts = mkMerge [
        (mkIf cfg.openFirewall tcpPorts)
        (mkIf cfg.web.openFirewall webPorts)
      ];
      allowedUDPPorts = mkIf cfg.openFirewall udpPorts;
    };
  };

  meta.maintainers = with maintainers; [ JManch ];
}
