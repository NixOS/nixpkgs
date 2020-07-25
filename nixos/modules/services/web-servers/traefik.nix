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
in {
  options.services.traefik = {
    enable = mkEnableOption "Traefik web server";

    staticConfigFile = mkOption {
      default = null;
      example = literalExample "/path/to/static_config.toml";
      type = types.nullOr types.path;
      description = ''
        Path to traefik's static configuration to use.
        (Using that option has precedence over <literal>staticConfigOptions</literal> and <literal>dynamicConfigOptions</literal>)
      '';
    };

    staticConfigOptions = mkOption {
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

    dynamicConfigFile = mkOption {
      default = null;
      example = literalExample "/path/to/dynamic_config.toml";
      type = types.nullOr types.path;
      description = ''
        Path to traefik's dynamic configuration to use.
        (Using that option has precedence over <literal>dynamicConfigOptions</literal>)
      '';
    };

    dynamicConfigOptions = mkOption {
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
        For the docker backend this needs to be set to <literal>docker</literal> instead.
      '';
    };

    package = mkOption {
      default = pkgs.traefik;
      defaultText = "pkgs.traefik";
      type = types.package;
      description = "Traefik package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 traefik traefik - -" ];

    systemd.services.traefik = {
      description = "Traefik web server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          "${cfg.package}/bin/traefik --configfile=${staticConfigFile}";
        Type = "simple";
        User = "traefik";
        Group = cfg.group;
        Restart = "on-failure";
        StartLimitInterval = 86400;
        StartLimitBurst = 5;
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
