{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.xandikos;

  inherit (lib)
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    ;

  inherit (lib.cli) toCommandLineShell;
  inherit (lib.generators) mkValueStringDefault;

  inherit (lib.types)
    attrsOf
    bool
    int
    nullOr
    oneOf
    port
    str
    submodule
    ;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "xandikos" "port" ] [ "services" "xandikos" "settings" "port" ])
    (mkRenamedOptionModule
      [ "services" "xandikos" "routePrefix" ]
      [ "services" "xandikos" "settings" "route-prefix" ]
    )
    (mkRenamedOptionModule
      [ "services" "xandikos" "address" ]
      [ "services" "xandikos" "settings" "listen-address" ]
    )
    (mkRemovedOptionModule [
      "services"
      "xandikos"
      "extraOptions"
    ] "Use ${options.services.xandikos.settings} instead.")
  ];

  options = {
    services.xandikos = {
      enable = mkEnableOption "Xandikos CalDAV and CardDAV server";

      package = mkPackageOption pkgs "xandikos" { };

      settings = mkOption {
        type = submodule {
          freeformType = attrsOf (
            nullOr (oneOf [
              str
              int
              bool
            ])
          );
          options = {
            port = mkOption {
              type = port;
              default = 8080;
              description = "The port of the Xandikos web application";
            };

            route-prefix = mkOption {
              type = str;
              default = "/";
              description = ''
                Path to Xandikos.
                Useful when Xandikos is behind a reverse proxy.
              '';
            };

            directory = mkOption {
              type = str;
              default = "/var/lib/xandikos";
              description = "Path to where Xandikos stores its internal data.";
            };

            listen-address = mkOption {
              type = str;
              default = "localhost";
              description = ''
                The IP address on which Xandikos will listen.
              '';
            };
          };
        };
        default = { };
        example = {
          autocreate = true;
          defaults = true;
          current-user-principal = "user";
          dump-dav-xml = true;
        };
        description = "Arguments passed to Xandikos";
      };

      domain = mkOption {
        type = nullOr str;
        description = ''
          If non-null, enables an nginx reverse proxy virtual host at this FQDN for xandikos.
        '';
        example = "xandikos.example.com";
      };

      nginx = mkOption {
        type = submodule {
          imports = [
            ../web-servers/nginx/vhost-options.nix
            ../../misc/assertions.nix
            (mkRemovedOptionModule [
              "enable"
            ] "Set ${options.services.xandikos.domain} to null if you want to disable the nginx integration.")
            (mkRemovedOptionModule [ "hostName" ] "Set ${options.services.xandikos.domain} instead.")
          ];
        };
        default = { };
        description = ''
          Configuration for nginx reverse proxy.
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ _0x4A6F ];

  config = mkIf cfg.enable {
    users.users.xandikos = {
      isSystemUser = true;
      group = "xandikos";
    };

    users.groups.xandikos = { };

    systemd.services.xandikos = {
      description = "A Simple Calendar and Contact Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "xandikos";
        Group = "xandikos";
        RuntimeDirectory = "xandikos";
        StateDirectory = "xandikos";
        StateDirectoryMode = "0700";
        RequiresMountsFor = [ cfg.settings.directory ];
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
          ${getExe cfg.package} ${
            toCommandLineShell (optionName: {
              option = if (builtins.stringLength optionName) > 1 then "--${optionName}" else "-${optionName}";
              sep = null;
              explicitBool = false;
              formatArg = mkValueStringDefault { };
            }) cfg.settings
          }
        '';
      };
    };

    services.nginx = mkIf (cfg.domain != null) {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.domain}" = mkMerge [
        (removeAttrs cfg.nginx [
          "enable"
          "hostName"
          "assertions"
          "warnings"
        ])
        {
          locations."${cfg.settings.route-prefix}" = {
            proxyPass = mkDefault "http://${cfg.settings.listen-address}:${toString cfg.settings.port}/";
            recommendedProxySettings = mkDefault true;
          };
        }
      ];
    };
  };
}
