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
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    optionalString
    recursiveUpdate
    types
    ;

  cfg = config.services.spotifyd;
  toml = pkgs.formats.toml { };

  defaultCachePath = "/var/cache/spotifyd";

  # Make sure we have a usable nix attrset to make assertions and warnings
  parsedSpotifydConf = if cfg.settings != { } then cfg.settings else builtins.fromTOML cfg.config;

  # Modify parsed config according to options
  spotifydConf =
    if cfg.credentialsFile != null then
      recursiveUpdate parsedSpotifydConf {
        ${if hasAttr "spotifyd" parsedSpotifydConf then "spotifyd" else "global"} = {
          username_cmd = "${getExe pkgs.jq} -r .username ${defaultCachePath}/credentials.json";
          cache_path = defaultCachePath;
        };
      }
    else
      parsedSpotifydConf;

  spotifydConfFile = toml.generate "spotify.conf" spotifydConf;

  # spotifyd takes precedence over global
  cachePath =
    if cfg.credentialsFile != null then
      defaultCachePath
    else
      (spotifydConf.spotifyd or spotifydConf.global).cache_path or defaultCachePath;
in
{
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      package = mkPackageOption pkgs "spotifyd" {
        example = "pkgs.spotifyd.override { withMpris = false; }";
      };

      credentialsFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          File that will be used by spotifyd to authenticate itself instead
          of using `settings.username`, `settings.password`, etc. which do
          not work anymore.

          This option also sets some settings such as `username_cmd` and `cache_path`
          in your spotifyd configuration.

          https://github.com/Spotifyd/spotifyd/issues/1293
        '';
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
      {
        assertion =
          !(
            hasAttr "password" (spotifydConf.spotifyd or spotifydConf.global)
            && hasAttr "password_cmd" (spotifydConf.spotifyd or spotifydConf.global)
          );
        message = "`password` and `password_cmd` cannot be set at the same time.";
      }
      {
        assertion =
          !(
            hasAttr "username" (spotifydConf.spotifyd or spotifydConf.global)
            && hasAttr "username_cmd" (spotifydConf.spotifyd or spotifydConf.global)
          );
        message = "`username` and `username_cmd` cannot be set at the same time.";
      }
      {
        assertion =
          !(
            cfg.credentialsFile != null
            && (
              hasAttr "password" (spotifydConf.spotifyd or spotifydConf.global)
              || hasAttr "password_cmd" (spotifydConf.spotifyd or spotifydConf.global)
              || hasAttr "username" (spotifydConf.spotifyd or spotifydConf.global)
            )
          );
      }
    ];

    warnings =
      optionals (cachePath != defaultCachePath) [
        ''Changing the `cache_path` setting in `services.spotifyd.settings...` will not ensure that the service will have read/write permissions for that directory${
          optionalString (cfg.credentialsFile != null) " and will not take care of the credentials file"
        }.''
      ]
      ++ optionals (cfg.config != "") [
        ''Using the stringly typed `services.spotifyd.config` attribute is discouraged. Use the TOML typed .settings attribute instead.''
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
        ExecStartPre = mkIf (
          cfg.credentialsFile != null
        ) "${pkgs.coreutils}/bin/cp -f ${cfg.credentialsFile} ${defaultCachePath}/credentials.json";
        ExecStart = "${getExe cfg.package} --no-daemon --config-path ${spotifydConfFile}";
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
