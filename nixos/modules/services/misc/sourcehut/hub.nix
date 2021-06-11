{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;
  scfg = cfg.hub;
  iniKey = "hub.sr.ht";

  drv = pkgs.sourcehut.hubsrht;
in
{
  options.services.sourcehut.hub = {
    user = mkOption {
      type = types.str;
      default = "hubsrht";
      description = ''
        User for hub.sr.ht.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5014;
      description = ''
        Port on which the "hub" module should listen.
      '';
    };

    database = mkOption {
      type = types.str;
      default = "hub.sr.ht";
      description = ''
        PostgreSQL database name for hub.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/hubsrht";
      description = ''
        State path for hub.sr.ht.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "hub" cfg.services) {
    users = {
      users = {
        "${user}" = {
          isSystemUser = true;
          group = user;
          description = "hub.sr.ht user";
        };
      };

      groups = {
        "${user}" = { };
      };
    };

    services.postgresql = {
      authentication = ''
        local ${database} ${user} trust
      '';
      ensureDatabases = [ database ];
      ensureUsers = [
        {
          name = user;
          ensurePermissions = { "DATABASE \"${database}\"" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd = {
      tmpfiles.rules = [
        "d ${statePath} 0750 ${user} ${user} -"
      ];

      services.hubsrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "hub.sr.ht website service";

        serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
      };
    };

    services.sourcehut.settings = {
      # URL hub.sr.ht is being served at (protocol://domain)
      "hub.sr.ht".origin = mkDefault "http://hub.${cfg.originBase}";
      # Address and port to bind the debug server to
      "hub.sr.ht".debug-host = mkDefault "0.0.0.0";
      "hub.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "hub.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "hub.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # hub.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "hub.sr.ht".oauth-client-id = mkDefault null;
      "hub.sr.ht".oauth-client-secret = mkDefault null;
    };

    services.nginx.virtualHosts."${cfg.originBase}" = {
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address}:${toString port}";
      locations."/query".proxyPass = "http://${cfg.address}:${toString (port + 100)}";
      locations."/static".root = "${pkgs.sourcehut.hubsrht}/${pkgs.sourcehut.python.sitePackages}/hubsrht";
    };
    services.nginx.virtualHosts."hub.${cfg.originBase}" = {
      globalRedirect = "${cfg.originBase}";
      forceSSL = true;
    };
  };
}
