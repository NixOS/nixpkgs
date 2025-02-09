{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.traefik;
  jsonValue = with types;
    let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        (lazyAttrsOf valueType)
        (listOf valueType)
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
            (recursiveUpdate cfg.staticConfigOptions {
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
    enable = mkEnableOption (lib.mdDoc "Traefik web server");

    staticConfigFile = mkOption {
      default = null;
      example = literalExpression "/path/to/static_config.toml";
      type = types.nullOr types.path;
      description = lib.mdDoc ''
        Path to traefik's static configuration to use.
        (Using that option has precedence over `staticConfigOptions` and `dynamicConfigOptions`)
      '';
    };

    staticConfigOptions = mkOption {
      description = lib.mdDoc ''
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

    dynamicConfigFile = mkOption {
      default = null;
      example = literalExpression "/path/to/dynamic_config.toml";
      type = types.nullOr types.path;
      description = lib.mdDoc ''
        Path to traefik's dynamic configuration to use.
        (Using that option has precedence over `dynamicConfigOptions`)
      '';
    };

    dynamicConfigOptions = mkOption {
      description = lib.mdDoc ''
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

    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = types.path;
      description = lib.mdDoc ''
        Location for any persistent data traefik creates, ie. acme
      '';
    };

    group = mkOption {
      default = "traefik";
      type = types.str;
      example = "docker";
      description = lib.mdDoc ''
        Set the group that traefik runs under.
        For the docker backend this needs to be set to `docker` instead.
      '';
    };

    package = mkPackageOption pkgs "traefik" { };

    environmentFiles = mkOption {
      default = [];
      type = types.listOf types.path;
      example = [ "/run/secrets/traefik.env" ];
      description = lib.mdDoc ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 traefik traefik - -" ];

    systemd.services.traefik = {
      description = "Traefik web server";
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
        ReadWriteDirectories = cfg.dataDir;
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
