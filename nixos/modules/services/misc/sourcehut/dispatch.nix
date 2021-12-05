{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.services.sourcehut;
  opt = options.services.sourcehut;
  cfgIni = cfg.settings;
  scfg = cfg.dispatch;
  iniKey = "dispatch.sr.ht";

  drv = pkgs.sourcehut.dispatchsrht;
in
{
  options.services.sourcehut.dispatch = {
    user = mkOption {
      type = types.str;
      default = "dispatchsrht";
      description = ''
        User for dispatch.sr.ht.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5005;
      description = ''
        Port on which the "dispatch" module should listen.
      '';
    };

    database = mkOption {
      type = types.str;
      default = "dispatch.sr.ht";
      description = ''
        PostgreSQL database name for dispatch.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/dispatchsrht";
      defaultText = literalExpression ''"''${config.${opt.statePath}}/dispatchsrht"'';
      description = ''
        State path for dispatch.sr.ht.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "dispatch" cfg.services) {

    users = {
      users = {
        "${user}" = {
          isSystemUser = true;
          group = user;
          description = "dispatch.sr.ht user";
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

      services.dispatchsrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "dispatch.sr.ht website service";

        serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
      };
    };

    services.sourcehut.settings = {
      # URL dispatch.sr.ht is being served at (protocol://domain)
      "dispatch.sr.ht".origin = mkDefault "http://dispatch.${cfg.originBase}";
      # Address and port to bind the debug server to
      "dispatch.sr.ht".debug-host = mkDefault "0.0.0.0";
      "dispatch.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "dispatch.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "dispatch.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # dispatch.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "dispatch.sr.ht".oauth-client-id = mkDefault null;
      "dispatch.sr.ht".oauth-client-secret = mkDefault null;

      # Github Integration
      "dispatch.sr.ht::github".oauth-client-id = mkDefault null;
      "dispatch.sr.ht::github".oauth-client-secret = mkDefault null;

      # Gitlab Integration
      "dispatch.sr.ht::gitlab".enabled = mkDefault null;
      "dispatch.sr.ht::gitlab".canonical-upstream = mkDefault "gitlab.com";
      "dispatch.sr.ht::gitlab".repo-cache = mkDefault "./repo-cache";
      # "dispatch.sr.ht::gitlab"."gitlab.com" = mkDefault "GitLab:application id:secret";
    };

    services.nginx.virtualHosts."dispatch.${cfg.originBase}" = {
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address}:${toString port}";
      locations."/query".proxyPass = "http://${cfg.address}:${toString (port + 100)}";
      locations."/static".root = "${pkgs.sourcehut.dispatchsrht}/${pkgs.sourcehut.python.sitePackages}/dispatchsrht";
    };
  };
}
