{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xandikos;

  listenStream =
    if cfg.address == null then
      [ "[::1]:${toString cfg.port}" "127.0.0.1:${toString cfg.port}" ]
    else if hasInfix "/" cfg.address then
      [ cfg.address ]
    else if hasInfix ":" cfg.address then
      [ "[${cfg.address}]:${toString cfg.port}" ]
    else
      [ "${cfg.address}:${toString cfg.port}" ]
    ;

  nginxProxyAddress =
    if hasInfix "/" (head listenStream) then
      "unix:${head listenStream}"
    else
      head listenStream
    ;
in
{

  options = {
    services.xandikos = {
      enable = mkEnableOption (lib.mdDoc "Xandikos CalDAV and CardDAV server");

      package = mkOption {
        type = types.package;
        default = pkgs.xandikos;
        defaultText = literalExpression "pkgs.xandikos";
        description = lib.mdDoc "The Xandikos package to use.";
      };

      address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          The IP address or socket path on which Xandikos will listen.
          By default listens on localhost.
        '';
        example = "/run/xandikos/socket";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc "The port of the Xandikos web application";
      };

      routePrefix = mkOption {
        type = types.str;
        default = "/";
        description = lib.mdDoc ''
          Path to Xandikos.
          Useful when Xandikos is behind a reverse proxy.
        '';
      };

      extraOptions = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExpression ''
          [ "--autocreate"
            "--defaults"
            "--current-user-principal user"
            "--dump-dav-xml"
          ]
        '';
        description = lib.mdDoc ''
          Extra command line arguments to pass to xandikos.
        '';
      };

      nginx = mkOption {
        default = {};
        description = lib.mdDoc ''
          Configuration for nginx reverse proxy.
        '';

        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Configure the nginx reverse proxy settings.
              '';
            };

            hostName = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                The hostname use to setup the virtualhost configuration
              '';
            };
          };
        };
      };

    };

  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        meta.maintainers = with lib.maintainers; [ _0x4A6F ];

        systemd.sockets.xandikos = {
          wantedBy = [ "sockets.target" ];
          socketConfig.ListenStream = listenStream;
        };

        systemd.services.xandikos = {
          description = "A Simple Calendar and Contact Server";
          serviceConfig = {
            User = "xandikos";
            Group = "xandikos";
            DynamicUser = "yes";
            RuntimeDirectory = "xandikos";
            StateDirectory = "xandikos";
            StateDirectoryMode = "0700";
            PrivateDevices = true;
            # Sandboxing
            CapabilityBoundingSet = "CAP_NET_RAW CAP_NET_ADMIN";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_PACKET AF_NETLINK";
            RestrictNamespaces = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            ExecStart = ''
              ${cfg.package}/bin/xandikos \
                --directory /var/lib/xandikos \
                --route-prefix ${cfg.routePrefix} \
                ${lib.concatStringsSep " " cfg.extraOptions}
            '';
          };
        };
      }

      (
        mkIf cfg.nginx.enable {
          services.nginx = {
            enable = true;
            virtualHosts."${cfg.nginx.hostName}" = {
              locations."/" = {
                proxyPass = "http://${nginxProxyAddress}";
              };
            };
          };
        }
      )
    ]
  );
}
