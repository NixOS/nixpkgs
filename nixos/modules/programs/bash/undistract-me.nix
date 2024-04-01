{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.bash.undistractMe;
in
{
  options = {
    programs.bash.undistractMe = {
      enable = mkEnableOption "notifications when long-running terminal commands complete";

      playSound = mkEnableOption "notification sounds when long-running terminal commands complete";

      timeout = mkOption {
        default = 10;
        description = lib.mdDoc ''
          Number of seconds it would take for a command to be considered long-running.
        '';
        type = types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.bash.promptPluginInit = ''
      export LONG_RUNNING_COMMAND_TIMEOUT=${toString cfg.timeout}
      export UDM_PLAY_SOUND=${if cfg.playSound then "1" else "0"}
      . "${pkgs.undistract-me}/etc/profile.d/undistract-me.sh"
    '';
  };

  meta = {
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
