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
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    ;

  inherit (lib.types)
    listOf
    nullOr
    port
    str
    submodule
    ;
in
{
  options = {
    services.xandikos = {
      enable = mkEnableOption "Xandikos CalDAV and CardDAV server";

      package = mkPackageOption pkgs "xandikos" { };

      address = mkOption {
        type = str;
        default = "localhost";
        description = ''
          The IP address on which Xandikos will listen.
          By default listens on localhost.
        '';
      };

      port = mkOption {
        type = port;
        default = 8080;
        description = "The port of the Xandikos web application";
      };

      routePrefix = mkOption {
        type = str;
        default = "/";
        description = ''
          Path to Xandikos.
          Useful when Xandikos is behind a reverse proxy.
        '';
      };

      extraOptions = mkOption {
        default = [ ];
        type = listOf str;
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
          locations."${cfg.routePrefix}" = {
            proxyPass = mkDefault "http://${cfg.address}:${toString cfg.port}/";
            recommendedProxySettings = mkDefault true;
          };
        }
      ];
    };
  };
}
