{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;
  scfg = cfg.meta;
  iniKey = "meta.sr.ht";

  drv = pkgs.sourcehut.metasrht;
in {
  options.services.sourcehut.meta = {
    user = mkOption {
      type = types.str;
      default = "metasrht";
      description = ''
        User for meta.sr.ht.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5000;
      description = ''
      '';
    };

    database = mkOption {
      type = types.str;
      default = "meta.sr.ht";
      description = ''
        PostgreSQL database name for meta.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/metasrht";
      description = ''
        State path for meta.sr.ht.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "meta" cfg.services) {
    assertions =
      [
        { assertion = with cfgIni."meta.sr.ht::billing"; enabled == "yes" -> (stripe-public-key != null && stripe-secret-key != null);
          message = "If meta.sr.ht::billing is enabled, the keys should be defined."; }
      ];

    users = {
      users = [
        { name = user;
          group = user;
          description = "meta.sr.ht user"; }
      ];

      groups = [
        { name = user; }
      ];
    };

    services.cron.systemCronJobs = [ "0 0 * * * ${cfg.python}/bin/metasrht-daily" ];
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
        metasrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "meta.sr.ht website service";

          preStart = ''
            # Configure client(s) as "preauthorized"
            ${concatMapStringsSep "\n\n"
              (attr: ''
                if ! test -e "${statePath}/${attr}.oauth" || [ "$(cat ${statePath}/${attr}.oauth)" != "${cfgIni."${attr}".oauth-client-id}" ]; then
                  # Configure ${attr}'s OAuth client as "preauthorized"
                  psql ${database} \
                    -c "UPDATE oauthclient SET preauthorized = true WHERE client_id = '${cfgIni."${attr}".oauth-client-id}'"

                  printf "%s" "${cfgIni."${attr}".oauth-client-id}" > "${statePath}/${attr}.oauth"
                fi
              '')
              (builtins.attrNames (filterAttrs
                (k: v: !(hasInfix "::" k) && builtins.hasAttr "oauth-client-id" v && v.oauth-client-id != null)
                cfg.settings))}
          '';

          serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
        };

        metasrht-webhooks = {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "meta.sr.ht webhooks service";
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
      # URL meta.sr.ht is being served at (protocol://domain)
      "meta.sr.ht".origin = mkDefault "http://meta.sr.ht.local";
      # Address and port to bind the debug server to
      "meta.sr.ht".debug-host = mkDefault "0.0.0.0";
      "meta.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "meta.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "meta.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # If "yes", the user will be sent the stock sourcehut welcome emails after
      # signup (requires cron to be configured properly). These are specific to the
      # sr.ht instance so you probably want to patch these before enabling this.
      "meta.sr.ht".welcome-emails = mkDefault "no";

      # If "no", public registration will not be permitted.
      "meta.sr.ht::settings".registration = mkDefault "no";
      # Where to redirect new users upon registration
      "meta.sr.ht::settings".onboarding-redirect = mkDefault "http://example.org";
      # How many invites each user is issued upon registration (only applicable if
      # open registration is disabled)
      "meta.sr.ht::settings".user-invites = mkDefault 5;

      # You can add aliases for the client IDs of commonly used OAuth clients here.
      #
      # Example:
      "meta.sr.ht::aliases" = mkDefault {};
      # "meta.sr.ht::aliases"."git.sr.ht" = 12345;

      # "yes" to enable the billing system
      "meta.sr.ht::billing".enabled = mkDefault "no";
      # Get your keys at https://dashboard.stripe.com/account/apikeys
      "meta.sr.ht::billing".stripe-public-key = mkDefault null;
      "meta.sr.ht::billing".stripe-secret-key = mkDefault null;
    };
  };
}
