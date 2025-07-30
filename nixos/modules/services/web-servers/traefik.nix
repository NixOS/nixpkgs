{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.traefik;

  format = pkgs.formats.toml { };

  dynamicConfigFile =
    if cfg.dynamicConfigFile == null then
      format.generate "config.toml" cfg.dynamicConfigOptions
    else
      cfg.dynamicConfigFile;

  staticConfigFile =
    if cfg.staticConfigFile == null then
      format.generate "config.toml" (
        lib.recursiveUpdate cfg.staticConfigOptions {
          providers.file.filename = "${dynamicConfigFile}";
        }
      )
    else
      cfg.staticConfigFile;

  finalStaticConfigFile =
    if cfg.environmentFiles == [ ] then staticConfigFile else "/run/traefik/config.toml";
in
{
  options.services.traefik = {
    enable = lib.mkEnableOption "Traefik web server";

    staticConfigFile = lib.mkOption {
      default = null;
      example = lib.literalExpression "/path/to/static_config.toml";
      type = with lib.types; nullOr path;
      description = ''
        Path to traefik's static configuration to use.
        (Using that option has precedence over `staticConfigOptions` and `dynamicConfigOptions`)
      '';
    };

    staticConfigOptions = lib.mkOption {
      description = ''
        Static configuration for Traefik.
      '';
      type = format.type;
      default = {
        entryPoints.http.address = ":80";
      };
      example = {
        entryPoints.web.address = ":8080";
        entryPoints.http.address = ":80";

        api = { };
      };
    };

    dynamicConfigFile = lib.mkOption {
      default = null;
      example = lib.literalExpression "/path/to/dynamic_config.toml";
      type = with lib.types; nullOr path;
      description = ''
        Path to traefik's dynamic configuration to use.
        (Using that option has precedence over `dynamicConfigOptions`)
      '';
    };

    dynamicConfigOptions = lib.mkOption {
      description = ''
        Dynamic configuration for Traefik.
      '';
      type = format.type;
      default = { };
      example = {
        http.routers.router1 = {
          rule = "Host(`localhost`)";
          service = "service1";
        };

        http.services.service1.loadBalancer.servers = [ { url = "http://localhost:8080"; } ];
      };
    };

    plugins = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf package;
      example = lib.literalExpression "[ pkgs.fosrl-badger ]";
      description = ''
        List of plugins to be added to the `localPlugins` attribute in the static configuration. These plugins are usually packaged in Nixpkgs, and are managed by Nix.
      '';
    };

    dataDir = lib.mkOption {
      default = "/var/lib/traefik";
      type = lib.types.path;
      description = ''
        Location for any persistent data traefik creates, ie. acme
      '';
    };

    group = lib.mkOption {
      default = "traefik";
      type = lib.types.str;
      example = "docker";
      description = ''
        Set the group that traefik runs under.
        For the docker backend this needs to be set to `docker` instead.
      '';
    };

    package = lib.mkPackageOption pkgs "traefik" { };

    environmentFiles = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.traefik.staticConfigOptions = lib.mkIf (cfg.plugins != [ ]) {
      experimental.localPlugins = lib.listToAttrs (
        map (plugin: lib.nameValuePair plugin.plugin { inherit (plugin) moduleName; }) cfg.plugins
      );
    };

    systemd.tmpfiles.settings."10-traefik" = lib.mkMerge [
      {
        ${cfg.dataDir}.d = {
          group = "traefik";
          mode = "0700";
          user = "traefik";
        };
      }
      (lib.mkIf (cfg.plugins != [ ]) {
        "${cfg.dataDir}/plugins-local"."L+".argument = toString (
          pkgs.symlinkJoin {
            name = "traefik-plugins";
            paths = cfg.plugins;
          }
        );
      })
    ];

    systemd.services.traefik = {
      description = "Traefik web server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre = lib.optional (cfg.environmentFiles != [ ]) (
          pkgs.writeShellScript "traefik-pre-start-envsubst" ''
            umask 077
            ${lib.getExe pkgs.envsubst} -i "${staticConfigFile}" > "${finalStaticConfigFile}"
          ''
        );
        ExecStart = "${cfg.package}/bin/traefik --configfile=${finalStaticConfigFile}";
        Type = "simple";
        User = "traefik";
        Group = cfg.group;
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNPROC = 64;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWritePaths = [ cfg.dataDir ];
        RuntimeDirectory = "traefik";
        WorkingDirectory = cfg.dataDir;
      };
    };

    users.users.traefik = {
      group = "traefik";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    users.groups.traefik = { };
  };
}
