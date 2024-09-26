{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    hasAttr
    id
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    types
    ;

  cfg = config.services.spotifyd;
  toml = pkgs.formats.toml { };

  warnConfig =
    if cfg.config != "" then
      lib.trace "Using the stringly typed .config attribute is discouraged. Use the TOML typed .settings attribute instead."
    else
      id;

  spotifydConf =
    if cfg.settings != { } then cfg.settings else warnConfig (builtins.fromTOML cfg.config);

  spotifydConfFile = toml.generate "spotify.conf" spotifydConf;

  defaultCachePath = "/var/cache/spotifyd";
  cachePath = (spotifydConf.spotifyd or spotifydConf.global).cache_path or defaultCachePath;
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      package = mkPackageOption pkgs "spotifyd" {
        example = "pkgs.spotifyd.override { withMpris = false; }";
      };

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
      {
        assertion = hasAttr "spotifyd" spotifydConf || hasAttr "global" spotifydConf;
        message = "A main spotifyd or global attribute must be set.";
      }
    ];

    warnings = optionals (cachePath != defaultCachePath) [
      ''Changing the `cache_path` setting will not ensure that the service will have read/write permissions for that directory.''
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
        ExecStart = "${getExe cfg.package} --no-daemon --cache-path ${cachePath} --config-path ${spotifydConfFile}";
        Restart = "always";
        RestartSec = 12;
        DynamicUser = true;
        CacheDirectory = mkIf (cachePath == defaultCachePath) "spotifyd";
        SupplementaryGroups = [ "audio" ];
      };
    };
  };

  meta.maintainers = [ maintainers.matt1432 ];
}
