{pkgs, config, ...}:
let
  cfg = config.security.apparmor;
in
with pkgs.lib;
{

  ###### interface

  options = {

    security.apparmor = {

      enable = mkOption {
        default = false;
        description = ''
          Enable AppArmor application security system
        '';
      };

      profiles = mkOption {
        default = [];
	merge = mergeListOption;
        description = ''
	  List of file names of AppArmor profiles.
	'';
      };

    };
  };


  ###### implementation

  config = mkIf (cfg.enable) {

    jobs.apparmor =
      { startOn = "startup";

	path = [ pkgs.apparmor ];

        preStart = concatMapStrings (profile: ''
          apparmor_parser -Kv -I ${pkgs.apparmor}/etc/apparmor.d/ "${profile}"
        '') cfg.profiles;

	postStop = ''
	'';
      };

  };

}
