{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;
  scfg = cfg.man;
  iniKey = "man.sr.ht";

  drv = pkgs.sourcehut.mansrht;
in {
  options.services.sourcehut.man = {
    user = mkOption {
      type = types.str;
      default = "mansrht";
      description = ''
        User for man.sr.ht.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5004;
      description = ''
      '';
    };

    database = mkOption {
      type = types.str;
      default = "man.sr.ht";
      description = ''
        PostgreSQL database name for man.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/mansrht";
      description = ''
        State path for man.sr.ht.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "man" cfg.services) {
    assertions =
      [
        { assertion = hasAttrByPath [ "git.sr.ht" "oauth-client-id" ] cfgIni;
          message = "man.sr.ht needs access to git.sr.ht."; }
      ];

    users = {
      users = [
        { name = user;
          group = user;
          description = "man.sr.ht user"; }
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

      services.mansrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "man.sr.ht website service";

        serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
      };
    };

    services.sourcehut.settings = {
      # URL man.sr.ht is being served at (protocol://domain)
      "man.sr.ht".origin = mkDefault "http://man.sr.ht.local";
      # Address and port to bind the debug server to
      "man.sr.ht".debug-host = mkDefault "0.0.0.0";
      "man.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "man.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "man.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # man.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "man.sr.ht".oauth-client-id = mkDefault null;
      "man.sr.ht".oauth-client-secret = mkDefault null;
    };
  };
}
