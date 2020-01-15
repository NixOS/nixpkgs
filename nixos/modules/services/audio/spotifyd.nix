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
      after = [ "network-online.target" "sound.target" ];
      description = "spotifyd, a Spotify playing daemon";
      serviceConfig = {
        ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache_path /var/cache/spotifyd --config ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
        DynamicUser = true;
        CacheDirectory = "spotifyd";
        SupplementaryGroups = ["audio"];
      };
    };
  };

  meta.maintainers = [ maintainers.anderslundstedt ];
}
