{ config, lib, pkgs, ... }:
let
  cfg = config.services.rss2email;
in {

  ###### interface

  options = {

    services.rss2email = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable rss2email.";
      };

      to = lib.mkOption {
        type = lib.types.str;
        description = "Mail address to which to send emails";
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = "12h";
        description = "How often to check the feeds, in systemd interval format";
      };

      config = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [ str int bool ]);
        default = {};
        description = ''
          The configuration to give rss2email.

          Default will use system-wide `sendmail` to send the
          email. This is rss2email's default when running
          `r2e new`.

          This set contains key-value associations that will be set in the
          `[DEFAULT]` block along with the
          `to` parameter.

          See `man r2e` for more information on which
          parameters are accepted.
        '';
      };

      feeds = lib.mkOption {
        description = "The feeds to watch.";
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "The URL at which to fetch the feed.";
            };

            to = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                Email address to which to send feed items.

                If `null`, this will not be set in the
                configuration file, and rss2email will make it default to
                `rss2email.to`.
              '';
            };
          };
        });
      };
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {
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

    environment.systemPackages = with pkgs; [ rss2email ];

    services.rss2email.config.to = cfg.to;

    systemd.tmpfiles.settings."10-rss2email"."/var/rss2email".d = {
      user = "rss2email";
      group = "rss2email";
      mode = "0700";
    };

    systemd.services.rss2email = let
      conf = pkgs.writeText "rss2email.cfg" (lib.generators.toINI {} ({
          DEFAULT = cfg.config;
        } // lib.mapAttrs' (name: feed: lib.nameValuePair "feed.${name}" (
          { inherit (feed) url; } //
          lib.optionalAttrs (feed.to != null) { inherit (feed) to; }
        )) cfg.feeds
      ));
    in
    {
      preStart = ''
        if [ ! -f /var/rss2email/db.json ]; then
          echo '{"version":2,"feeds":[]}' > /var/rss2email/db.json
        fi
      '';
      path = [ pkgs.system-sendmail ];
      serviceConfig = {
        ExecStart =
          "${pkgs.rss2email}/bin/r2e -c ${conf} -d /var/rss2email/db.json run";
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
