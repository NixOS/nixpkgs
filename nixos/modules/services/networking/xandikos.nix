{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xandikos;
in
{

  options = {
    services.xandikos = {
      enable = lib.mkEnableOption "Xandikos CalDAV and CardDAV server";

      package = lib.mkPackageOption pkgs "xandikos" { };

      address = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          The IP address on which Xandikos will listen.
          By default listens on localhost.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port of the Xandikos web application";
      };

      routePrefix = lib.mkOption {
        type = lib.types.str;
        default = "/";
        description = ''
          Path to Xandikos.
          Useful when Xandikos is behind a reverse proxy.
        '';
      };

      extraOptions = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        example = lib.literalExpression ''
          [ "--autocreate"
            "--defaults"
            "--current-user-principal user"
            "--dump-dav-xml"
          ]
        '';
        description = ''
          Extra command line arguments to pass to xandikos.
        '';
      };

      nginx = lib.mkOption {
        default = { };
        description = ''
          Configuration for nginx reverse proxy.
        '';

        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Configure the nginx reverse proxy settings.
              '';
            };

            hostName = lib.mkOption {
              type = lib.types.str;
              description = ''
                The hostname use to setup the virtualhost configuration
              '';
            };
          };
        };
      };

    };

  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      meta.maintainers = with lib.maintainers; [ _0x4A6F ];

      systemd.services.xandikos = {
        description = "A Simple Calendar and Contact Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

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
              --listen-address ${cfg.address} \
              --port ${toString cfg.port} \
              --route-prefix ${cfg.routePrefix} \
              ${lib.concatStringsSep " " cfg.extraOptions}
          '';
        };
      };
    }

    (lib.mkIf cfg.nginx.enable {
      services.nginx = {
        enable = true;
        virtualHosts."${cfg.nginx.hostName}" = {
          locations."/" = {
            proxyPass = "http://${cfg.address}:${toString cfg.port}/";
          };
        };
      };
    })
  ]);
}
