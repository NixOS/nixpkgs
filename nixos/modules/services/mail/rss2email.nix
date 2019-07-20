{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rss2email;
in {

  ###### interface

  options = {

    services.rss2email = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable rss2email.";
      };

      to = mkOption {
        type = types.str;
        description = "Mail address to which to send emails";
      };

      interval = mkOption {
        type = types.str;
        default = "12h";
        description = "How often to check the feeds, in systemd interval format";
      };

      config = mkOption {
        type = with types; attrsOf (either str (either int bool));
        default = {};
        description = ''
          The configuration to give rss2email.

          Default will use system-wide <literal>sendmail</literal> to send the
          email. This is rss2email's default when running
          <literal>r2e new</literal>.

          This set contains key-value associations that will be set in the
          <literal>[DEFAULT]</literal> block along with the
          <literal>to</literal> parameter.

          See
          <literal>https://github.com/rss2email/rss2email/blob/master/r2e.1</literal>
          for more information on which parameters are accepted.
        '';
      };

      feeds = mkOption {
        description = "The feeds to watch.";
        type = types.attrsOf (types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              description = "The URL at which to fetch the feed.";
            };

            to = mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                Email address to which to send feed items.

                If <literal>null</literal>, this will not be set in the
                configuration file, and rss2email will make it default to
                <literal>rss2email.to</literal>.
              '';
            };
          };
        });
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    users.groups = {
      rss2email.gid = config.ids.gids.rss2email;
    };

    users.users = {
      rss2email = {
        description = "rss2email user";
        uid = config.ids.uids.rss2email;
        group = "rss2email";
      };
    };

    services.rss2email.config.to = cfg.to;

    systemd.tmpfiles.rules = [
      "d /var/rss2email 0700 rss2email rss2email - -"
    ];

    systemd.services.rss2email = let
      conf = pkgs.writeText "rss2email.cfg" (lib.generators.toINI {} ({
          DEFAULT = cfg.config;
        } // lib.mapAttrs' (name: feed: nameValuePair "feed.${name}" (
          { inherit (feed) url; } //
          lib.optionalAttrs (feed.to != null) { inherit (feed) to; }
        )) cfg.feeds
      ));
    in
    {
      preStart = ''
        cp ${conf} /var/rss2email/conf.cfg
        if [ ! -f /var/rss2email/db.json ]; then
          echo '{"version":2,"feeds":[]}' > /var/rss2email/db.json
        fi
      '';
      path = [ pkgs.system-sendmail ];
      serviceConfig = {
        ExecStart =
          "${pkgs.rss2email}/bin/r2e -c /var/rss2email/conf.cfg -d /var/rss2email/db.json run";
        User = "rss2email";
      };
    };

    systemd.timers.rss2email = {
      partOf = [ "rss2email.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnBootSec = "0";
      timerConfig.OnUnitActiveSec = cfg.interval;
    };
  };

  meta.maintainers = with lib.maintainers; [ ekleog ];
}
