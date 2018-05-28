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
      default = "/run/meguca";
      description = "Location where meguca stores it's database and links.";
    };

    password = mkOption {
      type = types.str;
      default = "meguca";
      description = "Password for the meguca database.";
    };

    passwordFile = mkOption {
      type = types.path;
      default = "/run/keys/meguca-password-file";
      description = "Password file for the meguca database.";
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
      type = types.nullOr types.int;
      default = null;
      description = "Cache size in MB.";
    };

    postgresArgs = mkOption {
      type = types.str;
      default = "user=meguca password=" + cfg.password + " dbname=meguca sslmode=disable";
      description = "Postgresql connection arguments.";
    };

    postgresArgsFile = mkOption {
      type = types.path;
      default = "/run/keys/meguca-postgres-args";
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
    security.sudo.enable = cfg.enable == true;
    services.postgresql.enable = cfg.enable == true;

    services.meguca.passwordFile = mkDefault (toString (pkgs.writeTextFile {
      name = "meguca-password-file";
      text = cfg.password;
    }));

    services.meguca.postgresArgsFile = mkDefault (toString (pkgs.writeTextFile {
      name = "meguca-postgres-args";
      text = cfg.postgresArgs;
    }));

    systemd.services.meguca = {
      description = "meguca";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Ensure folder exists and links are correct or create them
        mkdir -p ${cfg.baseDir}
        ln -sf ${pkgs.meguca}/share/meguca/www ${cfg.baseDir}

        # Ensure the database is correct or create it
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/createuser \
          -SDR meguca || true
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/psql \
          -c "ALTER ROLE meguca WITH PASSWORD '$(cat ${cfg.passwordFile})';" || true
        ${pkgs.sudo}/bin/sudo -u ${postgres.superUser} ${postgres.package}/bin/createdb \
          -T template0 -E UTF8 -O meguca meguca || true
      '';

    script = ''
      cd ${cfg.baseDir}

      ${pkgs.meguca}/bin/meguca -d "$(cat ${cfg.postgresArgsFile})"\
        ${optionalString (cfg.reverseProxy != null) " -R ${cfg.reverseProxy}"}\
        ${optionalString (cfg.sslCertificate != null) " -S ${cfg.sslCertificate}"}\
        ${optionalString (cfg.listenAddress != null) " -a ${cfg.listenAddress}"}\
        ${optionalString (cfg.cacheSize != null) " -c ${toString cfg.cacheSize}"}\
        ${optionalString (cfg.compressTraffic) " -g"}\
        ${optionalString (cfg.assumeReverseProxy) " -r"}\
        ${optionalString (cfg.httpsOnly) " -s"} start
    '';

      serviceConfig = {
        PermissionsStartOnly = true;
        Type = "forking";
        User = "meguca";
        Group = "meguca";
        RuntimeDirectory = "meguca";
        ExecStop = "${pkgs.meguca}/bin/meguca stop";
      };
    };

    users = {
      extraUsers.meguca = {
        description = "meguca server service user";
        home = cfg.baseDir;
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

  meta.maintainers = with maintainers; [ chiiruno ];
}
