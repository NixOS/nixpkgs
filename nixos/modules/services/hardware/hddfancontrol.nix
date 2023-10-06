{ config, lib, pkgs, ... }:

let
  cfg = config.services.hddfancontrol;
  types = lib.types;
in

{
  options = {

    services.hddfancontrol.enable = lib.mkEnableOption (lib.mdDoc "hddfancontrol daemon");

    services.hddfancontrol.disks = lib.mkOption {
      type = with types; listOf path;
      default = [];
      description = lib.mdDoc ''
        Drive(s) to get temperature from
      '';
      example = ["/dev/sda"];
    };

    services.hddfancontrol.pwmPaths = lib.mkOption {
      type = with types; listOf path;
      default = [];
      description = lib.mdDoc ''
        PWM filepath(s) to control fan speed (under /sys)
      '';
      example = ["/sys/class/hwmon/hwmon2/pwm1"];
    };

    services.hddfancontrol.smartctl = lib.mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Probe temperature using smartctl instead of hddtemp or hdparm
      '';
    };

    services.hddfancontrol.extraArgs = lib.mkOption {
      type = with types; listOf str;
      default = [];
      description = lib.mdDoc ''
        Extra commandline arguments for hddfancontrol
      '';
      example = ["--pwm-start-value=32"
                 "--pwm-stop-value=0"
                 "--spin-down-time=900"];
    };
  };

  config = lib.mkIf cfg.enable (
    let args = lib.concatLists [
      ["-d"] cfg.disks
      ["-p"] cfg.pwmPaths
      (lib.optional cfg.smartctl "--smartctl")
      cfg.extraArgs
    ]; in {
      systemd.packages = [pkgs.hddfancontrol];

      systemd.services.hddfancontrol = {
        wantedBy = [ "multi-user.target" ];
        environment.HDDFANCONTROL_ARGS = lib.escapeShellArgs args;
      };
    }
  );
}
