{ config, lib, pkgs, ... }:

let
  cfg = config.services.hockeypuck;
  settingsFormat = pkgs.formats.toml { };
in {
  meta.maintainers = with lib.maintainers; [ etu ];

  options.services.hockeypuck = {
    enable = lib.mkEnableOption (lib.mdDoc "Hockeypuck OpenPGP Key Server");

    port = lib.mkOption {
      default = 11371;
      type = lib.types.port;
      description = lib.mdDoc "HKP port to listen on.";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          hockeypuck = {
            loglevel = "INFO";
            logfile = "/var/log/hockeypuck/hockeypuck.log";
            indexTemplate = "''${pkgs.hockeypuck-web}/share/templates/index.html.tmpl";
            vindexTemplate = "''${pkgs.hockeypuck-web}/share/templates/index.html.tmpl";
            statsTemplate = "''${pkgs.hockeypuck-web}/share/templates/stats.html.tmpl";
            webroot = "''${pkgs.hockeypuck-web}/share/webroot";

            hkp.bind = ":''${toString cfg.port}";

            openpgp.db = {
              driver = "postgres-jsonb";
              dsn = "database=hockeypuck host=/var/run/postgresql sslmode=disable";
            };
          };
        }
      '';
      description = ''
        Configuration file for hockeypuck, here you can override
        certain settings (<literal>loglevel</literal> and
        <literal>openpgp.db.dsn</literal>) by just setting those values.

        For other settings you need to use lib.mkForce to override them.

        This service doesn't provision or enable postgres on your
        system, it rather assumes that you enable postgres and create
        the database yourself.

        Example:
        <programlisting>
          services.postgresql = {
            enable = true;
            ensureDatabases = [ "hockeypuck" ];
            ensureUsers = [{
              name = "hockeypuck";
              ensurePermissions."DATABASE hockeypuck" = "ALL PRIVILEGES";
            }];
          };
        </programlisting>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.hockeypuck.settings.hockeypuck = {
      loglevel = lib.mkDefault "INFO";
      logfile = "/var/log/hockeypuck/hockeypuck.log";
      indexTemplate = "${pkgs.hockeypuck-web}/share/templates/index.html.tmpl";
      vindexTemplate = "${pkgs.hockeypuck-web}/share/templates/index.html.tmpl";
      statsTemplate = "${pkgs.hockeypuck-web}/share/templates/stats.html.tmpl";
      webroot = "${pkgs.hockeypuck-web}/share/webroot";

      hkp.bind = ":${toString cfg.port}";

      openpgp.db = {
        driver = "postgres-jsonb";
        dsn = lib.mkDefault "database=hockeypuck host=/var/run/postgresql sslmode=disable";
      };
    };

    users.users.hockeypuck = {
      isSystemUser = true;
      group = "hockeypuck";
      description = "Hockeypuck user";
    };
    users.groups.hockeypuck = {};

    systemd.services.hockeypuck = {
      description = "Hockeypuck OpenPGP Key Server";
      after = [ "network.target" "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        WorkingDirectory = "/var/lib/hockeypuck";
        User = "hockeypuck";
        ExecStart = "${pkgs.hockeypuck}/bin/hockeypuck -config ${settingsFormat.generate "config.toml" cfg.settings}";
        Restart = "always";
        RestartSec = "5s";
        LogsDirectory = "hockeypuck";
        LogsDirectoryMode = "0755";
        StateDirectory = "hockeypuck";
      };
    };
  };
}
