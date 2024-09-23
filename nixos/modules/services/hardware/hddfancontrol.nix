{ config, lib, pkgs, ... }:

let
  cfg = config.services.hddfancontrol;
  types = lib.types;
in

{
  options = {

    services.hddfancontrol.enable = lib.mkEnableOption "hddfancontrol daemon";

    services.hddfancontrol.disks = lib.mkOption {
      type = with types; listOf path;
      default = [];
      description = ''
        Drive(s) to get temperature from
      '';
      example = ["/dev/sda"];
    };

    services.hddfancontrol.pwmPaths = lib.mkOption {
      type = with types; listOf path;
      default = [];
      description = ''
        PWM filepath(s) to control fan speed (under /sys)
      '';
      example = ["/sys/class/hwmon/hwmon2/pwm1"];
    };

    services.hddfancontrol.smartctl = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Probe temperature using smartctl instead of hddtemp or hdparm
      '';
    };

    services.hddfancontrol.extraArgs = lib.mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
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
        serviceConfig = {
          # Hardening
          PrivateNetwork = true;
        };
      };
    }
  );
}
