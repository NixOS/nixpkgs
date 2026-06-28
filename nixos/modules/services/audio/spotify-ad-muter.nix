{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.spotify-ad-muter;
in
{
  options.services.spotify-ad-muter = {
    enable = lib.mkEnableOption "Spotify advertisement muter user service";

    package = lib.mkPackageOption pkgs "spotify-ad-muter" { };

    resumeDelay = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 2;
      description = "Seconds to wait after an advertisement ends before restoring Spotify audio.";
    };

    commandTimeout = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 2;
      description = "Seconds to wait for each playerctl and pactl command before treating it as failed.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.spotify-ad-muter = {
      description = "Mute Spotify advertisements";
      wantedBy = [ "default.target" ];
      after = [
        "dbus.service"
        "pipewire-pulse.service"
        "pulseaudio.service"
      ];
      environment = {
        SPOTIFY_AD_MUTER_RESUME_DELAY = toString cfg.resumeDelay;
        SPOTIFY_AD_MUTER_COMMAND_TIMEOUT = toString cfg.commandTimeout;
      };
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        ExecStopPost = "${lib.getExe cfg.package} --restore";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ luna5akura ];
}
