{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.gdnc;
in {
  options = {
    services.gdnc.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable gdnc, the GNUstep distributed notification center";
    };
  };
  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = config.services.gdnc.enable -> config.services.gdomap.enable;
      message = "Cannot start gdnc without starting gdomap";
    };
    environment.systemPackages = [ pkgs.gnustep_make pkgs.gnustep_base ];
    systemd.services.gdnc = {
      path = [ pkgs.gnustep_base ];
      description = "gdnc: GNUstep distributed notification center";
      requires = [ "gdomap.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkgs.gnustep_base}/bin/gdnc -f'';
        Restart = "always";
	RestartSec = 10;
	TimeoutStartSec = "30";
      };
    };
  };
}
