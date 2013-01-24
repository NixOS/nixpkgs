{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.spamassassin;

in

{

  ###### interface

  options = {

    services.spamassassin = {

      enable = mkOption {
        default = false;
        description = "Whether to run the SpamAssassin daemon.";
      };

      debug = mkOption {
        default = false;
        description = "Whether to run the SpamAssassin daemon in debug mode.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Allow users to run 'spamc'.
    environment.systemPackages = [ pkgs.spamassassin ];

    users.extraUsers = singleton {
    name = "spamd";
      description = "Spam Assassin Daemon";
      uid = config.ids.uids.spamd;
      group = "spamd";
    };

    users.extraGroups = singleton {
      name = "spamd";
      gid = config.ids.gids.spamd;
    };

    jobs.spamd = {
      description = "Spam Assassin Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment.TZ = config.time.timeZone;
      exec = "${pkgs.spamassassin}/bin/spamd ${optionalString cfg.debug "-D"} --username=spamd --groupname=spamd --nouser-config --virtual-config-dir=/var/lib/spamassassin/user-%u --allow-tell --pidfile=/var/run/spamd.pid";
    };

  };

}
