{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerd;
in {
  options = {
    services.powerd = {
      enable = mkEnableOption ''
        powerd to handle battery power levels
      '';
      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          User under which powerd works.
        '';
      };
      checkInterval = mkOption {
        type = types.ints.unsigned;
        default = 60;
        description = ''
          Sets the interval to check the battery level in seconds.
        '';
      };
      warnOnLevel = mkOption {
        type = types.ints.unsigned;
        default = 10;
        description = ''
          Sets the battery level which will trigger a warn message.
        '';
      };
      warnMessage = mkOption {
        type = types.str;
        default = "Battery level at 10%";
        description = ''
          Sets the warning message.
        '';
      };
      execOnLevel = mkOption {
        type = types.ints.unsigned;
        default = 5;
        description = ''
          Sets the battery level which will trigger a command execution.
        '';
      };
      execCommand = mkOption {
        type = types.str;
        default = "poweroff";
        description = ''
          Sets the exec command.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.powerd = {
      description = ''
        powerd - Simple daemon to handle battery power levels
      '';
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bash ];
      script = ''
          ${pkgs.powerd}/bin/powerd \
            --check-interval ${toString cfg.checkInterval} \
            --warn-on-level ${toString cfg.warnOnLevel} \
            --warn-message "${cfg.warnMessage}" \
            --exec-on-level ${toString cfg.execOnLevel} \
            --exec-command "${cfg.execCommand}"
      '';
      serviceConfig = {
        User = cfg.user;
      };
    };
  };

  meta.maintainers = [ maintainers.gnidorah ];
}
