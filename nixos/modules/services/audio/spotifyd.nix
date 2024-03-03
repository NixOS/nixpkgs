{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotifyd;
  toml = pkgs.formats.toml {};
  warnConfig =
    if cfg.config != ""
    then lib.trace "Using the stringly typed .config attribute is discouraged. Use the TOML typed .settings attribute instead."
    else id;
  spotifydConf =
    if cfg.settings != {}
    then toml.generate "spotify.conf" cfg.settings
    else warnConfig (pkgs.writeText "spotifyd.conf" cfg.config);
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption (lib.mdDoc "spotifyd, a Spotify playing daemon");

      config = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          (Deprecated) Configuration for Spotifyd. For syntax and directives, see
          <https://github.com/Spotifyd/spotifyd#Configuration>.
        '';
      };

      settings = mkOption {
        default = {};
        type = toml.type;
        example = { global.bitrate = 320; };
        description = lib.mdDoc ''
          Configuration for Spotifyd. For syntax and directives, see
          <https://github.com/Spotifyd/spotifyd#Configuration>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.config == "" || cfg.settings == {};
        message = "At most one of the .config attribute and the .settings attribute may be set";
      }
    ];

    systemd.services.spotifyd = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "sound.target" ];
      description = "spotifyd, a Spotify playing daemon";
      environment.SHELL = "/bin/sh";
      serviceConfig = {
        ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache-path /var/cache/spotifyd --config-path ${spotifydConf}";
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
