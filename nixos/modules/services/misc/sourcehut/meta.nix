{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  mecfg = cfg.meta;
in {
  options = {
    services.sourcehut.meta = {
      settings.registration = mkOption {
        type = types.enum [ "yes" "no" ];
        default = "no";
        description = ''
          Whether or not to allow public registration.
        '';
      };

      settings.onboardingRedirect = mkOption {
        type = types.str;
        default = "http://example.org";
        description = ''
          Where to redirect new users upon registration.
        '';
      };

      settings.userInvites = mkOption {
        type = types.int;
        default = 5;
        description = ''
          How many invites each user is issued upon registration, only
          applicable if open registration is disabled.
        '';
      };

      settings.extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for meta.sr.ht::settings.
        '';
      };

      aliases = mkOption {
        type = types.attrsOf (types.either types.int types.str);
        default = {};
        example = { "git.sr.ht" = 12345; };
        description = ''
          Aliases for the client IDs of commonly used OAuth clients here.
        '';
      };

      billing.enable = mkOption {
        type = types.enum [ "yes" "no" ];
        default = "no";
        description = ''
          Whether or not to enable the billing system.
        '';
      };

      billing.stripePubKey = mkOption {
        type = types.str;
        default = "";
        description = ''
          Public key from stripe, https://dashboard.stripe.com/account/apikeys.
        '';
      };

      billing.stripeSecretKey = mkOption {
        type = types.str;
        default = "";
        description = ''
          Private key from stripe, https://dashboard.stripe.com/account/apikeys.
        '';
      };

      billing.extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for meta.sr.ht::billing.
        '';
      };
    };
  };

  config = mkIf mecfg.enable {
    users = {
      users = [
        { name = mecfg.user;
          group = mecfg.user;
          description = "meta.sr.ht user"; } ];

      groups = [
        { name = mecfg.user; } ];
    };

    services.cron.systemCronJobs = singleton "0 0 * * * ${cfg.python}/bin/metasrht-daily";

    systemd.services = {
      "meta.sr.ht" = {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "meta.sr.ht website service";

        preStart = ''
          # Update copy of each users' profile to the latest
          # See https://lists.sr.ht/~sircmpwn/sr.ht-admins/<20190302181207.GA13778%40cirno.my.domain>
          ${concatMapStringsSep "\n\n"
            (service: ''
              if ! test -e ${mecfg.statePath}/${service}/webhook; then
                # Update ${service}'s users' profile copy to the latest
                ${cfg.python}/bin/srht-update-profile ${service}.sr.ht

                touch ${mecfg.statePath}/${service}/webhook
              fi
            '')
            cfg.services}

          # Configure client(s) as "preauthorized"
          ${concatMapStringsSep "\n\n"
            (service: let
              serviceConfig = cfg."${service}";
              pgSuperUser = config.services.postgresql.superUser;
            in ''
              if ! test -e ${mecfg.statePath}/${service}/oauth || [ "$(cat ${mecfg.statePath}/${service}/oauth)" != "${serviceConfig.oauth.clientId}" ]; then
                # Configure ${service}'s OAuth client as "preauthorized"
                sudo -u ${pgSuperUser} psql ${mecfg.database.dbname} \
                  -c "UPDATE oauthclient SET preauthorized = true WHERE client_id = '${serviceConfig.oauth.clientId}'"

                printf "%s" "${serviceConfig.oauth.clientId}" > ${mecfg.statePath}/${service}/oauth
              fi
            '')
            (filter
              (service: builtins.hasAttr "oauth" cfg."${service}" && cfg."${service}".oauth.clientId != "")
              cfg.services)}
        '';

        script = ''
          gunicorn metasrht.app:app \
            -b ${cfg.address}:${toString mecfg.port}
        '';
      };

      "meta.sr.ht-webhooks" = {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "meta.sr.ht webhooks service";
        path = singleton cfg.python;
        serviceConfig = {
          Type = "simple";
          User = mecfg.user;
          Restart = "always";
        };

        script = ''
          celery \
            -A metasrht.webhooks worker \
            --loglevel=info
        '';
      };
    };
  };
}
