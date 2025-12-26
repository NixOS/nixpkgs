{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xandikos;

  nginxProxyAddress =
    let
      first = head (toList cfg.address);
    in
    if hasInfix "/" first then "unix:${first}" else first;
in
{

  imports = [
    (mkRemovedOptionModule [ "services" "xandikos" "port" ] "Use services.xandikos.address")
  ];

  options = {
    services.xandikos = {
      enable = mkEnableOption "Xandikos CalDAV and CardDAV server";

      package = mkPackageOption pkgs "xandikos" { };

      address = mkOption {
        description = ''
          systemd ListenStream where Xandikos shall listen, see {manpage}`systemd.socket(5)`
        '';
        type =
          with types;
          oneOf [
            str
            (listOf str)
          ];
        default = [
          "127.0.0.1:8080"
          "[::1]:8080"
        ];
        example = [
          "0.0.0.0:8080"
          "[::]:8080"
          "/run/xandikos/socket"
        ];
      };

      routePrefix = mkOption {
        type = types.str;
        default = "/";
        description = ''
          Path to Xandikos.
          Useful when Xandikos is behind a reverse proxy.
        '';
      };

      extraOptions = mkOption {
        default = [ ];
        type = types.listOf types.str;
        example = literalExpression ''
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

      nginx = mkOption {
        default = { };
        description = ''
          Configuration for nginx reverse proxy.
        '';

        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Configure the nginx reverse proxy settings.
              '';
            };

            hostName = mkOption {
              type = types.str;
              description = ''
                The hostname use to setup the virtualhost configuration
              '';
            };
          };
        };
      };

      metrics = {
        enable = mkEnableOption "Xandikos' metrics";

        address = mkOption {
          description = ''
            systemd ListenStream where the Xandikos metrics shall listen, see {manpage}`systemd.socket(5)`
          '';
          type =
            with types;
            oneOf [
              str
              (listOf str)
            ];
          default = [
            "127.0.0.1:8081"
            "[::1]:8081"
          ];
          example = [
            "0.0.0.0:8081"
            "[::]:8081"
            "/run/xandikos/metrics.socket"
          ];
        };
      };

    };

  };

  meta.maintainers = with lib.maintainers; [ _0x4A6F ];

  config = mkIf cfg.enable (mkMerge [
    {

      systemd.sockets.xandikos = {
        wantedBy = [ "sockets.target" ];
        socketConfig.ListenStream = cfg.address;
      };

      systemd.services.xandikos = {
        description = "A Simple Calendar and Contact Server";
        requires = [ "xandikos.socket" ];
        after = [ "xandikos.socket" ];

        serviceConfig = {
          User = "xandikos";
          Group = "xandikos";
          DynamicUser = "yes";
          RuntimeDirectory = "xandikos";
          StateDirectory = "xandikos";
          StateDirectoryMode = "0700";
          PrivateDevices = true;
          # Systemd socket activation was broken time and again and bugs with
          # default listening addresses introduced. See
          #   * https://github.com/jelmer/xandikos/issues/134
          #   * https://github.com/jelmer/xandikos/pull/133
          #   * https://github.com/jelmer/xandikos/pull/136
          #   * https://github.com/jelmer/xandikos/pull/155
          #   * https://github.com/jelmer/xandikos/issues/260
          #   * https://github.com/jelmer/xandikos/pull/262
          # Additionally --metrics-port reuses --listen-address, which
          # defaults to 0.0.0.0/::. To avoid all this behaviour having
          # unwanted side-effects we run it in a private network namespace.
          # The metrics are made accesible through `xandikos-metrics.socket`.
          PrivateNetwork = true;
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
              ${lib.concatStringsSep " " (
                lib.optionals cfg.metrics.enable [
                  "--metrics-port"
                  "8081"
                ]
                ++ cfg.extraOptions
              )}
          '';
        };
      };
    }

    (mkIf cfg.metrics.enable {
      systemd.sockets.xandikos-metrics = {
        wantedBy = [ "sockets.target" ];
        socketConfig.ListenStream = cfg.metrics.address;
      };

      systemd.services.xandikos-metrics = {
        description = "A proxy to Xandikos' metrics";
        # see https://www.freedesktop.org/software/systemd/man/systemd-socket-proxyd.html#Namespace%20Example
        requires = [
          "xandikos.service"
          "xandikos-metrics.socket"
        ];
        after = [
          "xandikos.service"
          "xandikos-metrics.socket"
        ];
        unitConfig.JoinsNamespaceOf = "xandikos.service";
        serviceConfig = {
          Type = "notify";
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd localhost:8081";
          PrivateNetwork = true; # required by JoinsNamespaceOf
        };
      };
    })

    (mkIf cfg.nginx.enable {
      services.nginx = {
        enable = true;
        virtualHosts."${cfg.nginx.hostName}" = {
          locations."/" = {
            proxyPass = "http://${nginxProxyAddress}";
          };
        };
      };
    })
  ]);
}
