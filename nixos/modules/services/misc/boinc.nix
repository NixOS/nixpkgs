{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.boinc;
in
{
  options = {

    services.boinc = {

      enable = mkOption {
        default = false;
	description = "Whether to enable the Berkeley Open Infrastructure for Network Computing (BOINC) worker.";
      };

      home = mkOption {
	default = "/var/lib/boinc";
	description = "Location of BOINC work directory.";
      };

      user = mkOption {
        default = "boinc";
	description = "user that shall run BOINC.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.bonic = mkIf (cfg.user == "boinc") {
      uid = config.ids.uids.boinc;
      description = "BOINC user";
    };

    environment.systemPackages = [ pkgs.boinc ];

    systemd.services.boinc = {
      description = "Berkeley Open Infrastructure for Network Computing worker";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.boinc ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.boinc}/bin/boinc";
        User = cfg.user;
        WorkingDirectory="${config.services.boinc.home}";
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
      };
    };

    system.activationScripts.boinc = ''
      mkdir -p "${cfg.home}"
      chown -R "${cfg.user}" "${cfg.home}"
    '';
  };
}
