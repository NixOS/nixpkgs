{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.logkeys;
in
{
  options.services.logkeys = {
    enable = mkEnableOption "logkeys, a keylogger service";

    device = mkOption {
      description = "Use the given device as keyboard input event device instead of /dev/input/eventX default.";
      default = null;
      type = types.nullOr types.str;
      example = "/dev/input/event15";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.logkeys = {
      description = "LogKeys Keylogger Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.logkeys}/bin/logkeys -s${
          lib.optionalString (cfg.device != null) " -d ${cfg.device}"
        }";
        ExecStop = "${pkgs.logkeys}/bin/logkeys -k";
        Type = "forking";
      };
    };
  };
}
