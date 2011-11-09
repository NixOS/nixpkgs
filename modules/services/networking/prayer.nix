{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) prayer;

  stateDir = "/var/lib/prayer";

  prayerUser = "prayer";
  prayerGroup = "prayer";

  prayerExtraCfg = pkgs.writeText "extraprayer.cf" ''
    prefix = "${prayer}"
    var_prefix = "${stateDir}"
    prayer_user = "${prayerUser}"
    prayer_group = "${prayerGroup}"
    sendmail_path = "/var/setuid-wrappers/sendmail"

    ${config.services.prayer.extraConfig}
  '';

  prayerCfg = pkgs.runCommand "prayer.cf" { } ''
    cat ${prayer}/etc/prayer.cf ${prayerExtraCfg} > $out
  '';

in

{

  ###### interface

  options = {

    services.prayer = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the machine as a HTTP proxy server.
        '';
      };

      listenAddress = mkOption {
        default = "127.0.0.1:8118";
        description = ''
          Address the proxy server is listening to.
        '';
      };

      logDir = mkOption {
        default = "/var/log/prayer" ;
        description = ''
          Location for prayer log files.
        '';
      };

      extraConfig = mkOption {
        default = "" ;
        description = ''
          Extra configuration. Contents will be added verbatim to the configuration file.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.prayer.enable {
    environment.systemPackages = [ prayer ];

    users.extraUsers = singleton
      { name = prayerUser;
        uid = config.ids.uids.prayer;
        description = "prayer daemon user";
        home = stateDir;
      };

    users.extraGroups = singleton
      { name = prayerGroup;
        gid = config.ids.gids.prayer;
      };

    jobs.prayer =
      { name = "prayer";

        startOn = "startup";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${prayerUser}.${prayerGroup} ${stateDir}
          '';

        daemonType = "daemon";

        exec = "${prayer}/sbin/prayer --config-file=${prayerCfg}";
      };
  };

}
