{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mozhi;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;

  engines = [
    "google"
    "reverso"
    "deepl"
    "libretranslate"
    "yandex"
    "mymemory"
    "duckduckgo"
  ];
in
{
  options.services.mozhi = {
    enable = mkEnableOption "the Mozhi alternative translation frontend";
    package = mkPackageOption pkgs "mozhi" { };

    openFirewall = mkEnableOption "" // {
      description = "Whether to open the defined port in the firewall for the frontend.";
    };

    host = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The host to listen on. If null, defaults to listening on all interfaces.";
      example = "127.0.0.1";
    };

    port = mkOption {
      type = with types; nullOr types.port;
      default = 3000;
      description = "The port to listen on for this instance.";
    };

    libreTranslateURL = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The URL of LibreTranslate to use for querying an external instance.";
      example = "https://lt.psf.lt";
    };

    preferAutoDetect = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to prefer autodetection instead of specified/default source language for this instance.";
      example = true;
    };

    sourceLang = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The default source language to use when translating from. If null, defaults to autodetect (or first available language in engines which don't support it).";
      example = "en";
    };

    targetLang = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The default target language to use when translating to. If null, defaults to English.";
      example = "de";
    };

    defaultEngine = mkOption {
      type = with types; nullOr (types.enum engines);
      default = null;
      description = "The default engine to use on this instance. If not null, it must be enabled in the enabledEngines option.";
      example = "libretranslate";
    };

    enabledEngines = mkOption {
      type = types.listOf (types.enum engines);
      default = engines;
      description = "The list of engines to enable on this instance.";
      example = [
        "libretranslate"
        "duckduckgo"
      ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enabledEngines != [ ];
        message = "At least one engine must be enabled.";
      }
      {
        assertion = cfg.defaultEngine == null || lib.elem cfg.defaultEngine cfg.enabledEngines;
        message = "The specified default engine must be listed in enabledEngines.";
      }
    ];

    systemd.services.mozhi = {
      description = "Mozhi alternative translation frontend service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        MOZHI_HOST = mkIf (cfg.host != null) cfg.host;
        MOZHI_PORT = toString cfg.port;
        MOZHI_LIBRETRANSLATE_URL = mkIf (cfg.libreTranslateURL != null) cfg.libreTranslateURL;
        MOZHI_DEFAULT_PREFER_AUTODETECT = toString cfg.preferAutoDetect;
        MOZHI_DEFAULT_SOURCE_LANG = mkIf (cfg.sourceLang != null) cfg.sourceLang;
        MOZHI_DEFAULT_TARGET_LANG = mkIf (cfg.targetLang != null) cfg.targetLang;
        MOZHI_DEFAULT_ENGINE = mkIf (cfg.defaultEngine != null) cfg.defaultEngine;
      }
      // lib.listToAttrs (
        map (engine: {
          name = "MOZHI_${lib.toUpper engine}_ENABLED";
          value = "true";
        }) cfg.enabledEngines
      );

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve";
        Restart = "always";
        RestartSec = 10;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = [ lib.maintainers.ryand56 ];
}
