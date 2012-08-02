{ config, pkgs, ... }:
with pkgs.lib;
let
  clamavUser = "clamav";
  stateDir = "/var/lib/clamav";
  clamavGroup = clamavUser;
  cfg = config.services.clamav;
in
{
  ###### interface

  options = {

    services.clamav = {
      updater = {
	enable = mkOption {
	  default = false;
	  description = ''
	    Whether to enable automatic ClamAV virus definitions database updates.
	  '';
	};

	frequency = mkOption {
	  default = 12;
	  description = ''
	    Number of database checks per day.
	  '';
	};

	config = mkOption {
	  default = "";
	  description = ''
	    Extra configuration for freshclam. Contents will be added verbatim to the
	    configuration file.
	  '';
	};
      };
    };
  };

  ###### implementation

  config = mkIf cfg.updater.enable {
    environment.systemPackages = [ pkgs.clamav ];
    users.extraUsers = singleton
      { name = clamavUser;
        uid = config.ids.uids.clamav;
        description = "ClamAV daemon user";
        home = stateDir;
      };

    users.extraGroups = singleton
      { name = clamavGroup;
        gid = config.ids.gids.clamav;
      };

    services.clamav.updater.config = ''
      DatabaseDirectory ${stateDir}
      Foreground yes
      Checks ${toString cfg.updater.frequency}
      DatabaseMirror database.clamav.net
    '';

    jobs = {
      clamav_updater = {
	name = "clamav-updater";
          startOn = "started network-interfaces";
          stopOn = "stopping network-interfaces";

          preStart = ''
            mkdir -m 0755 -p ${stateDir}
            chown ${clamavUser}:${clamavGroup} ${stateDir}
          '';
          exec = "${pkgs.clamav}/bin/freshclam --config-file=${pkgs.writeText "freshclam.conf" cfg.updater.config}";
      }; 
    };

  };

}