{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.mpdscheduler;
in {
  options.services.mpdscheduler = {
    enable = mkEnableOption "mpdscheduler service";
    host = mkOption {
      type = types.str;
      description = "The mpd host to connect to.";
      default = "localhost";
      example = "mpdHost.local";
    };
    port = mkOption {
      type = types.port;
      description = "The mpd tcp port to connect to.";
      default = 6600;
    };
    additionalChannels = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the 'alarm', 'sleep' and 'cancel' channels shall be used in addition to the 'scheduler' channel.";
    };
    fadeTime = mkOption {
      type = types.ints.unsigned;
      default = 30;
      description = "Alarm/sleep fade time in seconds.";
      example = 15;
    };
    maxVolume = mkOption {
      type = types.ints.between 0 100;
      default = 100;
      description = "The volume to wake at in percent.";
      example = 50;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mpdscheduler = {
      wantedBy = [ "multi-user.target" ];
      environment = {
        MPD_HOST = cfg.host;
        MPD_PORT = "${toString cfg.port}";
        MPDSCHEDULER_FADE_TIME = "${toString cfg.fadeTime}";
        MPDSCHEDULER_MAX_VOLUME = "${toString cfg.maxVolume}";
        MPDSCHEDULER_ADDITIONAL_CHANNELS = if cfg.additionalChannels then "1" else "0";
      };
      after = [
        "network.target"
        (mkIf (cfg.host == "localhost") "mpd.service")
      ];
      serviceConfig.ExecStart = "${pkgs.mpdscheduler}/bin/mpdscheduler";
    };
  };

  meta.maintainers = [ maintainers.aberDerBart ];
}

