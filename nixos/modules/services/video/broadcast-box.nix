{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    attrNames
    types
    match
    optional
    optionals
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
  httpRedirect = settings.ENABLE_HTTP_REDIRECT or (settings.HTTPS_REDIRECT_PORT != null);

  udpPorts =
    optional (settings.UDP_MUX_PORT != null) settings.UDP_MUX_PORT
    ++ optional (settings.UDP_WHEP_PORT != null) settings.UDP_WHEP_PORT
    ++ optional (settings.UDP_WHIP_PORT != null) settings.UDP_WHIP_PORT;
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

      openFirewall = mkEnableOption ''
        opening the HTTP server port and, if enabled, the HTTPS redirect server
        port in the firewall.
      '';
    };

    openFirewall = mkEnableOption ''
      opening WebRTC traffic ports in the firewall. Randomly selected ports
      will not be opened.
    '';

    settings = mkOption {
      visible = "shallow";

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
        options = {
          TCP_MUX_ADDRESS = mkOption {
            type = with types; nullOr (strMatching ".*:[0-9]+");
            default = null;
          };

          DISABLE_STATUS = mkOption {
            type = types.bool;
            default = true;
          };

          UDP_MUX_PORT = mkOption {
            type = with types; nullOr port;
            default = null;
          };

          UDP_WHEP_PORT = mkOption {
            type = with types; nullOr port;
            default = null;
          };

          UDP_WHIP_PORT = mkOption {
            type = with types; nullOr port;
            default = null;
          };

          ENABLE_HTTP_REDIRECT = mkOption {
            type = types.bool;
            default = false;
          };

          HTTPS_REDIRECT_PORT = mkOption {
            type = with types; nullOr port;
            default = if settings.ENABLE_HTTP_REDIRECT then 80 else null;
          };
        };
      };

      default = {
        DISABLE_STATUS = true;
      };

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
          _: value:
          if (builtins.typeOf value == "bool") then
            if !value then null else "true"
          else if (builtins.typeOf value == "int") then
            toString value
          else
            value
        ) cfg.settings)
        // {
          APP_ENV = "nixos";
          HTTP_ADDRESS = cfg.web.host + ":" + toString cfg.web.port;
        };

      serviceConfig =
        let
          priviledgedPort = any (p: p > 0 && p < 1024) (udpPorts ++ tcpPorts ++ webPorts);
        in
        {
          ExecStart = "${getExe cfg.package}";
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
      allowedTCPPorts = optionals cfg.openFirewall tcpPorts ++ optionals cfg.web.openFirewall webPorts;
      allowedUDPPorts = optionals cfg.openFirewall udpPorts;
    };
  };

  meta.maintainers = with maintainers; [ JManch ];
}
