{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

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
        recursiveUpdate cfg.staticConfigOptions {
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
    enable = mkEnableOption "Traefik web server";

    staticConfigFile = mkOption {
      default = null;
      example = literalExpression "/path/to/static_config.toml";
      type = types.nullOr types.path;
      description = ''
        Path to traefik's static configuration to use.
        (Using that option has precedence over `staticConfigOptions` and `dynamicConfigOptions`)
      '';
    };

    staticConfigOptions = mkOption {
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

    dynamicConfigFile = mkOption {
      default = null;
      example = literalExpression "/path/to/dynamic_config.toml";
      type = types.nullOr types.path;
      description = ''
        Path to traefik's dynamic configuration to use.
        (Using that option has precedence over `dynamicConfigOptions`)
      '';
    };

    dynamicConfigOptions = mkOption {
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

    plugins = mkOption {
      default = [ ];
      type = types.listOf types.package;
      example = lib.literalExpression "[ pkgs.fosrl-badger ]";
      description = ''
        List of plugins to be added to the `localPlugins` attribute in the static configuration. These plugins are usually packaged in Nixpkgs, and are managed by Nix.
      '';
    };

    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = types.path;
      description = ''
        Location for any persistent data traefik creates, ie. acme
      '';
    };

    group = mkOption {
      default = "traefik";
      type = types.str;
      example = "docker";
      description = ''
        Set the group that traefik runs under.
        For the docker backend this needs to be set to `docker` instead.
      '';
    };

    package = mkPackageOption pkgs "traefik" { };

    environmentFiles = mkOption {
      default = [ ];
      type = types.listOf types.path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.traefik.staticConfigOptions.experimental.localPlugins = listToAttrs (
      map (plugin: nameValuePair plugin.pname { inherit (plugin) moduleName; }) cfg.plugins
    );

    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 traefik traefik - -" ];

    systemd.services.traefik = {
      description = "Traefik web server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre =
          optional (cfg.plugins != [ ]) (
            let
              pluginsJoined = pkgs.symlinkJoin {
                name = "traefik-plugins";
                paths = cfg.plugins;
              };
            in
            pkgs.writeShellScript "traefik-pre-start-plugins" ''
              umask 077
              ${getExe' pkgs.coreutils "ln"} -s ${pluginsJoined} plugins-local
            ''
          )
          ++ optional (cfg.environmentFiles != [ ]) (
            pkgs.writeShellScript "traefik-pre-start-envsubst" ''
              umask 077
              ${getExe pkgs.envsubst} -i "${staticConfigFile}" > "${finalStaticConfigFile}"
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
