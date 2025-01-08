{ config, lib, pkgs, ... }:

let
  cfg = config.services.traefik;
  jsonValue =
    let
      valueType = lib.types.nullOr (lib.types.oneOf [
        lib.types.bool
        lib.types.int
        lib.types.float
        lib.types.str
        (lib.types.lazyAttrsOf valueType)
        (lib.types.listOf valueType)
      ]) // {
        description = "JSON value";
        emptyValue.value = { };
      };
    in valueType;
  dynamicConfigFile = if cfg.dynamicConfigFile == null then
    pkgs.runCommand "config.toml" {
      buildInputs = [ pkgs.remarshal ];
      preferLocalBuild = true;
    } ''
      remarshal -if json -of toml \
        < ${
          pkgs.writeText "dynamic_config.json"
          (builtins.toJSON cfg.dynamicConfigOptions)
        } \
        > $out
    ''
  else
    cfg.dynamicConfigFile;
  staticConfigFile = if cfg.staticConfigFile == null then
    pkgs.runCommand "config.toml" {
      buildInputs = [ pkgs.yj ];
      preferLocalBuild = true;
    } ''
      yj -jt -i \
        < ${
          pkgs.writeText "static_config.json" (builtins.toJSON
            (lib.recursiveUpdate cfg.staticConfigOptions {
              providers.file.filename = "${dynamicConfigFile}";
            }))
        } \
        > $out
    ''
  else
    cfg.staticConfigFile;

  finalStaticConfigFile =
    if cfg.environmentFiles == []
    then staticConfigFile
    else "/run/traefik/config.toml";
in {
  options.services.traefik = {
    enable = lib.mkEnableOption "Traefik web server";

    staticConfigFile = lib.mkOption {
      default = null;
      example = lib.literalExpression "/path/to/static_config.toml";
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to traefik's static configuration to use.
        (Using that option has precedence over `staticConfigOptions` and `dynamicConfigOptions`)
      '';
    };

    staticConfigOptions = lib.mkOption {
      description = ''
        Static configuration for Traefik.
      '';
      type = jsonValue;
      default = { entryPoints.http.address = ":80"; };
      example = {
        entryPoints.web.address = ":8080";
        entryPoints.http.address = ":80";

        api = { };
      };
    };

    dynamicConfigFile = lib.mkOption {
      default = null;
      example = lib.literalExpression "/path/to/dynamic_config.toml";
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to traefik's dynamic configuration to use.
        (Using that option has precedence over `dynamicConfigOptions`)
      '';
    };

    dynamicConfigOptions = lib.mkOption {
      description = ''
        Dynamic configuration for Traefik.
      '';
      type = jsonValue;
      default = { };
      example = {
        http.routers.router1 = {
          rule = "Host(`localhost`)";
          service = "service1";
        };

        http.services.service1.loadBalancer.servers =
          [{ url = "http://localhost:8080"; }];
      };
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
      default = [];
      type = lib.types.listOf lib.types.path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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
        ExecStartPre = lib.optional (cfg.environmentFiles != [])
          (pkgs.writeShellScript "pre-start" ''
            umask 077
            ${pkgs.envsubst}/bin/envsubst -i "${staticConfigFile}" > "${finalStaticConfigFile}"
          '');
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
