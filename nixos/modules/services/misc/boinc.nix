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
        default = "nobody";
	description = "User that shall run BOINC.";
      };
    };
  };

  config = mkIf cfg.enable {

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
        WorkingDirectory = cfg.home;
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass   = "idle";
      };
    };

    system.activationScripts.boinc = ''
      ${pkgs.coreutils}/bin/mkdir -p "${cfg.home}"
      ${pkgs.coreutils}/bin/chown -R "${cfg.user}" "${cfg.home}"
    '';
  };
}
