{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.traefik;
  configFile =
    if cfg.configFile == null then
      pkgs.runCommand "config.toml" {
        buildInputs = [ pkgs.remarshal ];
        preferLocalBuild = true;
      } ''
        remarshal -if json -of toml \
          < ${pkgs.writeText "config.json" (builtins.toJSON cfg.configOptions)} \
          > $out
      ''
    else cfg.configFile;

in {
  options.services.traefik = {
    enable = mkEnableOption "Traefik web server";

    configFile = mkOption {
      default = null;
      example = literalExample "/path/to/config.toml";
      type = types.nullOr types.path;
      description = ''
        Path to verbatim traefik.toml to use.
        (Using that option has precedence over <literal>configOptions</literal>)
      '';
    };

    configOptions = mkOption {
      description = ''
        Config for Traefik.
      '';
      type = types.attrs;
      default = {
        defaultEntryPoints = ["http"];
        entryPoints.http.address = ":80";
      };
      example = {
        defaultEntrypoints = [ "http" ];
        web.address = ":8080";
        entryPoints.http.address = ":80";

        file = {};
        frontends = {
          frontend1 = {
            backend = "backend1";
            routes.test_1.rule = "Host:localhost";
          };
        };
        backends.backend1 = {
          servers.server1.url = "http://localhost:8000";
        };
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
      type = types.string;
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
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 traefik traefik - -"
    ];

    systemd.services.traefik = {
      description = "Traefik web server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package.bin}/bin/traefik --configfile=${configFile}'';
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
    };

    users.groups.traefik = {};
  };
}
