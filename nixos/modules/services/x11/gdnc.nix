{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.gdnc;
in {
  options = {
    services.gdnc.enable = mkEnableOption "Enable gdnc, the GNUstep distributed notification center";
  };
  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = config.services.gdnc.enable -> config.services.gdomap.enable;
      message = "Cannot start gdnc without starting gdomap";
    };
    environment.systemPackages = [ pkgs.gnustep.make pkgs.gnustep.base ];
    systemd.services.gdnc = {
      path = [ pkgs.gnustep.base ];
      description = "gdnc: GNUstep distributed notification center";
      requires = [ "gdomap.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.gnustep.base}/bin/gdnc -f
	'';
        Restart = "always";
	RestartSec = 10;
	TimeoutStartSec = "30";
      };
    };
  };
}
