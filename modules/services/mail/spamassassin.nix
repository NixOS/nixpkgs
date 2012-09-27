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

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Allow users to run 'spamc'.
    environment.systemPackages = [ pkgs.spamassassin ];

    users.extraUsers = singleton
      { name = "spamd";
        description = "Spam Assassin Daemon";
        uid = config.ids.uids.spamd;
      };

    jobs.spamd = {
      description = "Spam Assassin Server";
      startOn = "started networking and filesystem";
      environment.TZ = config.time.timeZone;
      exec = "${pkgs.spamassassin}/bin/spamd -D --username=spamd --pidfile=/var/run/spamd.pid";
    };

  };

}
