{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;
  scfg = cfg.paste;
  iniKey = "paste.sr.ht";

  drv = pkgs.sourcehut.pastesrht;
in {
  options.services.sourcehut.paste = {
    user = mkOption {
      type = types.str;
      default = "pastesrht";
      description = ''
        User for paste.sr.ht.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5011;
      description = ''
      '';
    };

    database = mkOption {
      type = types.str;
      default = "paste.sr.ht";
      description = ''
        PostgreSQL database name for paste.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/pastesrht";
      description = ''
        State path for pastesrht.sr.ht.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "paste" cfg.services) {
    users = {
      users = [
        { name = user;
          group = user;
          description = "paste.sr.ht user"; }
      ];

      groups = [
        { name = user; }
      ];
    };

    services.postgresql = {
      authentication = ''
        local ${database} ${user} trust
      '';
      ensureDatabases = [ database ];
      ensureUsers = [
        { name = user;
          ensurePermissions = { "DATABASE \"${database}\"" = "ALL PRIVILEGES"; }; }
      ];
    };

    systemd = {
      tmpfiles.rules = [
        "d ${statePath} 0750 ${user} ${user} -"
      ];

      services = {
        pastesrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "paste.sr.ht website service";

          serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
        };

        pastesrht-webhooks = {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "paste.sr.ht webhooks service";
          serviceConfig = {
            Type = "simple";
            User = user;
            Restart = "always";
          };

          serviceConfig.ExecStart = "${cfg.python}/bin/celery -A ${drv.pname}.webhooks worker --loglevel=info";
        };
      };
    };

    services.sourcehut.settings = {
      # URL paste.sr.ht is being served at (protocol://domain)
      "paste.sr.ht".origin = mkDefault "http://paste.sr.ht.local";
      # Address and port to bind the debug server to
      "paste.sr.ht".debug-host = mkDefault "0.0.0.0";
      "paste.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "paste.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "paste.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # paste.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "paste.sr.ht".oauth-client-id = mkDefault null;
      "paste.sr.ht".oauth-client-secret = mkDefault null;
    };
  };
}
