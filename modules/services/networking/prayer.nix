{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) prayer;

  cfg = config.services.prayer;

  stateDir = "/var/lib/prayer";

  prayerUser = "prayer";
  prayerGroup = "prayer";

  prayerExtraCfg = pkgs.writeText "extraprayer.cf" ''
    prefix = "${prayer}"
    var_prefix = "${stateDir}"
    prayer_user = "${prayerUser}"
    prayer_group = "${prayerGroup}"
    sendmail_path = "/var/setuid-wrappers/sendmail"

    use_http_port ${cfg.port}

    ${cfg.extraConfig}
  '';

  prayerCfg = pkgs.runCommand "prayer.cf" { } ''
    # We have to remove the http_port 80, or it will start a server there
    cat ${prayer}/etc/prayer.cf | grep -v http_port > $out
    cat ${prayerExtraCfg} >> $out
  '';

in

{

  ###### interface

  options = {

    services.prayer = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the prayer webmail http server.
        '';
      };

      port = mkOption {
        default = "2080";
        description = ''
          Port the prayer http server is listening to.
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
        description = "Prayer daemon user";
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
