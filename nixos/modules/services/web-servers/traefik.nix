{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.traefik;
  configFile =
    if cfg.configFile == null then
      pkgs.runCommand "config.toml" {
        buildInputs = [ pkgs.remarshal ];
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
      example = /path/to/config.toml;
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

    package = mkOption {
      default = pkgs.traefik;
      defaultText = "pkgs.traefik";
      type = types.package;
      description = "Traefik package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.traefik = {
      description = "Traefik web server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        ExecStart = ''${cfg.package.bin}/bin/traefik --configfile=${configFile}'';
        ExecStartPre = [
          ''${pkgs.coreutils}/bin/mkdir -p "${cfg.dataDir}"''
          ''${pkgs.coreutils}/bin/install -d -m700 --owner traefik --group traefik "${cfg.dataDir}"''
        ];
        Type = "simple";
        User = "traefik";
        Group = "traefik";
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

    users.extraUsers.traefik = {
      group = "traefik";
      home = cfg.dataDir;
      createHome = true;
    };

    users.extraGroups.traefik = {};
  };
}
