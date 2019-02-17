{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotifyd;
  spotifydConf = pkgs.writeText "spotifyd.conf" cfg.config;
  spotifyd = pkgs.callPackage (import ../../../../pkgs/applications/audio/spotifyd/default.nix) { };
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      dataDir = mkOption {
        default = "/var/lib/spotifyd";
        type = types.path;
        description = "The directory where spotifyd stores its state.";
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
      preStart = ''mkdir -p "${cfg.dataDir}" && chown -R spotifyd:spotifyd "${cfg.dataDir}"'';
      serviceConfig = {
        ExecStart = "${spotifyd}/bin/spotifyd --no-daemon --config ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
        User = "spotifyd";
      };
    };

    users = {
      users.spotifyd = {
        description = "spotifyd user";
        group = "spotifyd";
        extraGroups = [ "audio" ];
        home = cfg.dataDir;
      };

      groups.spotifyd = {};
    };
  };
}
