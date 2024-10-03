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
    hasAttr
    attrNames
    types
    match
    optional
    ;
  inherit (cfg) settings;
  cfg = config.services.broadcast-box;

  addressToPort = address: lib.toInt (lib.last (lib.splitString ":" address));
  httpPort = cfg.port;
  tcpMuxPort = addressToPort settings.TCP_MUX_ADDRESS;
  httpRedirect = settings.ENABLE_HTTP_REDIRECT or (settings.HTTPS_REDIRECT_PORT != null);

  udpPorts =
    optional (settings.UDP_MUX_PORT != null) settings.UDP_MUX_PORT
    ++ optional (settings.UDP_WHEP_PORT != null) settings.UDP_WHEP_PORT
    ++ optional (settings.UDP_WHIP_PORT != null) settings.UDP_WHIP_PORT;

  tcpPorts =
    [ httpPort ]
    ++ optional httpRedirect settings.HTTPS_REDIRECT_PORT
    ++ optional (settings.TCP_MUX_ADDRESS != null) tcpMuxPort;
in
{
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(settings ? HTTP_ADDRESS);
        message = ''
          The Broadcast Box `HTTP_ADDRESS` variable should not be used. Instead
          use the `address` and `port` options.
        '';
      }
      {
        assertion = httpRedirect -> (hasAttr settings "SSL_CERT" && hasAttr settings "SSL_KEY");
        message = ''
          The Broadcast Box `ENABLE_HTTP_REDIRECT` variable requires `SSL_CERT`
          and `SSL_KEY` to be configured.
        '';
      }
      {
        assertion = httpRedirect -> (httpPort == 443);
        message = ''
          Broadcast Box HTTP redirect only works if the HTTP server listen port
          is 443.
        '';
      }
      {
        assertion = lib.allUnique tcpPorts;
        message = ''
          Broadcast Box configuration contains duplicate TCP ports.
        '';
      }
      {
        assertion = lib.all (name: (match "[A-Z0-9_]+" name) != null) (attrNames settings);
        message =
          let
            offenders = lib.filter (name: (match "[A-Z0-9_]+" name) == null) (attrNames settings);
          in
          ''
            Broadcast Box `settings` attribute names must be in uppercase snake
            case. Invalid attribute name(s): `${lib.concatStringsSep ", " offenders}`
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

      environment =
        (lib.mapAttrs (
          _: value:
          if (builtins.typeOf value == "bool") then
            if (!value) then null else "true"
          else if (builtins.typeOf value == "int") then
            toString value
          else
            value
        ) cfg.settings)
        // {
          APP_ENV = "nixos";
          HTTP_ADDRESS = cfg.address + ":" + toString cfg.port;
        };

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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = tcpPorts;
      allowedUDPPorts = udpPorts;
    };
  };

  options.services.broadcast-box = {
    enable = mkEnableOption "Broadcast Box";
    package = mkPackageOption pkgs "broadcast-box" { };

    address = mkOption {
      type = types.str;
      default = "";
      example = "127.0.0.1";
      description = ''
        Address for the HTTP server to listen on. If not specified, the server
        will listen on all interfaces.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Port the HTTP server will listen on.
      '';
    };

    openFirewall = mkEnableOption ''
      opening of the utilised ports in the firewall. Any port options that
      result in random port selection will not be opened.

      This option does not apply an interface filter.
    '';

    settings = mkOption {
      visible = "shallow";

      type = lib.types.submodule {
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
        Configuration environment variables. Attribute names must be in
        uppercase snake case.

        A list of available environment variables can be found
        [here](https://github.com/Glimesh/broadcast-box?tab=readme-ov-file#environment-variables).

        Note: {env}`DISABLE_STATUS` is enabled by default as the status API
        exposes stream keys.
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ JManch ];
}
