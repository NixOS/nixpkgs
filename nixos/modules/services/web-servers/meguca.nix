{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.meguca;
  postgres = config.services.postgresql;
in
{
  options.services.meguca = {
    enable = mkEnableOption "meguca";

    baseDir = mkOption {
      type = types.path;
      default = "/var/lib/meguca";
      description = "Location where meguca stores it's database and links.";
    };

    password = mkOption {
      type = types.str;
      default = "meguca";
      description = "Password for the meguca database.";
    };

    reverseProxy = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Reverse proxy IP.";
    };

    sslCertificate = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to the SSL certificate.";
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Listen on a specific IP address and port.";
    };

    cacheSize = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Cache size in MB.";
    };

    postgresArgs = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Postgresql connection arguments.";
    };

    compressTraffic = mkOption {
      type = types.bool;
      default = false;
      description = "Compress all traffic with gzip.";
    };

    assumeReverseProxy = mkOption {
      type = types.bool;
      default = false;
      description = "Assume the server is behind a reverse proxy, when resolving client IPs.";
    };

    httpsOnly = mkOption {
      type = types.bool;
      default = false;
      description = "Serve and listen only through HTTPS.";
    };
  };

  config = mkIf cfg.enable {
    security.sudo.enable = cfg.enable == true;
    services.postgresql.enable = cfg.enable == true;

    systemd.services.meguca = {
      description = "meguca";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Ensure folder exists and links are correct or create them
        mkdir -p ${cfg.baseDir}
        ln -sf ${pkgs.meguca}/share/meguca/www ${cfg.baseDir}
        chown -R meguca:meguca ${cfg.baseDir}

        # Ensure the database is correct or create it
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/createuser -SDR meguca || true
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/psql -c "ALTER ROLE meguca WITH PASSWORD '${cfg.password}';" || true
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/createdb -T template0 -E UTF8 -O meguca meguca || true
      '';

      serviceConfig = {
        PermissionsStartOnly = true;
        Type = "forking";
        User = "meguca";
        Group = "meguca";
        WorkingDirectory = "${cfg.baseDir}";
        ExecStart = ''${pkgs.meguca}/bin/meguca${if cfg.reverseProxy != null then " -R ${cfg.reverseProxy}" else ""}${if cfg.sslCertificate != null then " -S ${cfg.sslCertificate}" else ""}${if cfg.listenAddress != null then " -a ${cfg.listenAddress}" else ""}${if cfg.cacheSize != null then " -c ${cfg.cacheSize}" else ""}${if cfg.postgresArgs != null then " -d  ${cfg.postgresArgs}" else ""}${if cfg.compressTraffic then " -g" else ""}${if cfg.assumeReverseProxy then " -r" else ""}${if cfg.httpsOnly then " -s" else ""} start'';
        ExecStop = "${pkgs.meguca}/bin/meguca stop";
        ExecRestart = "${pkgs.meguca}/bin/meguca restart";
      };
    };

    users = {
      extraUsers.meguca = {
        description = "meguca server service user";
        home = "${cfg.baseDir}";
        createHome = true;
        group = "meguca";
        uid = config.ids.uids.meguca;
      };

      extraGroups.meguca = {
        gid = config.ids.gids.meguca;
        members = [ "meguca" ];
      };
    };
  };

  meta.maintainers = [ maintainers.chiiruno ];
}
