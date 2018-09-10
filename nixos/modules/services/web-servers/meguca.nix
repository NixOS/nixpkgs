{ config, lib, pkgs, ... }:

let
  cfg = config.services.meguca;
  pg = config.services.postgresql;
in with lib; {
  options.services.meguca = {
    enable = mkEnableOption "meguca";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/meguca";
      example = "/home/okina/meguca";
      description = "Location where meguca stores it's database and links.";
    };

    password = mkOption {
      type = types.str;
      default = "meguca";
      example = "dumbpass";
      description = "Password for the meguca database.";
    };

    passwordFile = mkOption {
      type = types.path;
      default = "/run/keys/meguca-password-file";
      example = "/home/okina/meguca/keys/pass";
      description = "Password file for the meguca database.";
    };

    reverseProxy = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "192.168.1.5";
      description = "Reverse proxy IP.";
    };

    sslCertificate = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/okina/meguca/ssl.cert";
      description = "Path to the SSL certificate.";
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "127.0.0.1:8000";
      description = "Listen on a specific IP address and port.";
    };

    cacheSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 256;
      description = "Cache size in MB.";
    };

    postgresArgs = mkOption {
      type = types.str;
      example = "user=meguca password=dumbpass dbname=meguca sslmode=disable";
      description = "Postgresql connection arguments.";
    };

    postgresArgsFile = mkOption {
      type = types.path;
      default = "/run/keys/meguca-postgres-args";
      example = "/home/okina/meguca/keys/postgres";
      description = "Postgresql connection arguments file.";
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
    security.sudo.enable = cfg.enable;
    services.postgresql.enable = cfg.enable;
    services.meguca.passwordFile = mkDefault (pkgs.writeText "meguca-password-file" cfg.password);
    services.meguca.postgresArgsFile = mkDefault (pkgs.writeText "meguca-postgres-args" cfg.postgresArgs);
    services.meguca.postgresArgs = mkDefault "user=meguca password=${cfg.password} dbname=meguca sslmode=disable";

    systemd.services.meguca = {
      description = "meguca";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Ensure folder exists or create it and links and permissions are correct
        mkdir -p ${escapeShellArg cfg.dataDir}
        ln -sf ${pkgs.meguca}/share/meguca/www ${escapeShellArg cfg.dataDir}
        chmod 750 ${escapeShellArg cfg.dataDir}
        chown -R meguca:meguca ${escapeShellArg cfg.dataDir}

        # Ensure the database is correct or create it
        ${pkgs.sudo}/bin/sudo -u ${pg.superUser} ${pg.postgresqlPackage}/bin/createuser \
          -SDR meguca || true
        ${pkgs.sudo}/bin/sudo -u ${pg.superUser} ${pg.postgresqlPackage}/bin/createdb \
          -T template0 -E UTF8 -O meguca meguca || true
        ${pkgs.sudo}/bin/sudo -u meguca ${pg.postgresqlPackage}/bin/psql \
          -c "ALTER ROLE meguca WITH PASSWORD '$(cat ${escapeShellArg cfg.passwordFile})';" || true
      '';

    script = ''
      cd ${escapeShellArg cfg.dataDir}

      ${pkgs.meguca}/bin/meguca -d "$(cat ${escapeShellArg cfg.postgresArgsFile})"''
      + optionalString (cfg.reverseProxy != null) " -R ${cfg.reverseProxy}"
      + optionalString (cfg.sslCertificate != null) " -S ${cfg.sslCertificate}"
      + optionalString (cfg.listenAddress != null) " -a ${cfg.listenAddress}"
      + optionalString (cfg.cacheSize != null) " -c ${toString cfg.cacheSize}"
      + optionalString (cfg.compressTraffic) " -g"
      + optionalString (cfg.assumeReverseProxy) " -r"
      + optionalString (cfg.httpsOnly) " -s" + " start";

      serviceConfig = {
        PermissionsStartOnly = true;
        Type = "forking";
        User = "meguca";
        Group = "meguca";
        ExecStop = "${pkgs.meguca}/bin/meguca stop";
      };
    };

    users = {
      groups.meguca.gid = config.ids.gids.meguca;

      users.meguca = {
        description = "meguca server service user";
        home = cfg.dataDir;
        createHome = true;
        group = "meguca";
        uid = config.ids.uids.meguca;
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "meguca" "baseDir" ] [ "services" "meguca" "dataDir" ])
  ];

  meta.maintainers = with maintainers; [ chiiruno ];
}
