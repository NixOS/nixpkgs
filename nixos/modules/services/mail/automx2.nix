{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.automx2;
  format = pkgs.formats.json { };
in
{
  options = {
    services.automx2 = {
      enable = lib.mkEnableOption "automx2";

      package = lib.mkPackageOption pkgs [
        "python3Packages"
        "automx2"
      ] { };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "example.com";
        description = ''
          E-Mail-Domain for which mail client autoconfig/autoconfigure should be set up.
          The `autoconfig` and `autodiscover` subdomains are automatically prepended and set up with ACME.
          The names of those domains are hardcoded in the mail clients and are not configurable.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 4243;
        description = "Port used by automx2.";
      };

      settings = lib.mkOption {
        inherit (format) type;
        description = ''
          Bootstrap json to populate database.
          See [docs](https://rseichter.github.io/automx2/#_sqlite) for details.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = {
        "autoconfig.${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          serverAliases = [ "autodiscover.${cfg.domain}" ];
          locations = {
            "/".proxyPass = "http://127.0.0.1:${toString cfg.port}/";
            "/initdb".extraConfig = ''
              # Limit access to clients connecting from localhost
              allow 127.0.0.1;
              deny all;
            '';
          };
        };
      };
    };

    systemd.services.automx2 = {
      after = [ "network.target" ];
      postStart = ''
        sleep 3
        ${lib.getExe pkgs.curl} -X POST --json @${format.generate "automx2.json" cfg.settings} http://127.0.0.1:${toString cfg.port}/initdb/
      '';
      serviceConfig = {
        Environment = [
          "AUTOMX2_CONF=${pkgs.writeText "automx2-conf" ''
            [automx2]
            loglevel = WARNING
            db_uri = sqlite:///:memory:
            proxy_count = 1
          ''}"
          "FLASK_APP=automx2.server:app"
          "FLASK_CONFIG=production"
        ];
        ExecStart = "${
          pkgs.python3.buildEnv.override { extraLibs = [ cfg.package ]; }
        }/bin/flask run --host=127.0.0.1 --port=${toString cfg.port}";
        Restart = "always";
        StateDirectory = "automx2";
        User = "automx2";
        WorkingDirectory = "/var/lib/automx2";
      };
      unitConfig = {
        Description = "MUA configuration service";
        Documentation = "https://rseichter.github.io/automx2/";
      };
      wantedBy = [ "multi-user.target" ];
    };

    users = {
      groups.automx2 = { };
      users.automx2 = {
        group = "automx2";
        isSystemUser = true;
      };
    };
  };
}
