{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotifyd;
  spotifydConf = pkgs.writeText "spotifyd.conf" cfg.config;
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      dataDir = mkOption {
        default = "spotifyd";
        type = types.str;
        description = "The directory where spotifyd stores its state, relative to /var/lib/.";
      };

      config = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Configuration for Spotifyd. For syntax and directives, see
          https://github.com/Spotifyd/spotifyd#Configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.spotifyd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "sound.target" ];
      description = "spotifyd, a Spotify playing daemon";
      serviceConfig = {
        ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --config ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
        DynamicUser = true;
        StateDirectory = "${cfg.dataDir}";
        Environment = "HOME=/var/lib/${cfg.dataDir}";
      };
    };
  };
}
