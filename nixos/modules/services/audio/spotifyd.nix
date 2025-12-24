{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.spotifyd;
  toml = pkgs.formats.toml { };
  spotifydConf = toml.generate "spotify.conf" cfg.settings;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "spotifyd"
      "config"
    ] "Use the TOML typed `services.spotifyd.settings` instead.")
  ];

  options = {
    services.spotifyd = {
      enable = lib.mkEnableOption "spotifyd, a Spotify playing daemon";

      settings = lib.mkOption {
        default = { };
        type = toml.type;
        example = {
          global.bitrate = 320;
        };
        description = ''
          Configuration for Spotifyd. For syntax and directives, see
          <https://docs.spotifyd.rs/configuration/index.html#config-file>.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.spotifyd = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "sound.target"
      ];
      description = "spotifyd, a Spotify playing daemon";
      environment.SHELL = "/bin/sh";
      serviceConfig = {
        ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache-path /var/cache/spotifyd --config-path ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
        DynamicUser = true;
        CacheDirectory = "spotifyd";
        SupplementaryGroups = [ "audio" ];
      };
    };
  };

  meta.maintainers = [ lib.maintainers.anderslundstedt ];
}
