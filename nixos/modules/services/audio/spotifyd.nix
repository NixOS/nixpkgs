{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.spotifyd;
  toml = pkgs.formats.toml { };
  warnConfig =
    if cfg.config != "" then
      lib.trace "Using the stringly typed .config attribute is discouraged. Use the TOML typed .settings attribute instead."
    else
      id;
  spotifydConf =
    if cfg.settings != { } then
      toml.generate "spotify.conf" cfg.settings
    else
      warnConfig (pkgs.writeText "spotifyd.conf" cfg.config);
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      config = mkOption {
        default = "";
        type = types.lines;
        description = ''
          (Deprecated) Configuration for Spotifyd. For syntax and directives, see
          <https://docs.spotifyd.rs/config/File.html>.
        '';
      };

      settings = mkOption {
        default = { };
        type = toml.type;
        example = {
          global.bitrate = 320;
        };
        description = ''
          Configuration for Spotifyd. For syntax and directives, see
          <https://docs.spotifyd.rs/config/File.html>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.config == "" || cfg.settings == { };
        message = "At most one of the .config attribute and the .settings attribute may be set";
      }
    ];

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

  meta.maintainers = [ maintainers.anderslundstedt ];
}
