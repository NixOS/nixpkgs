{ config, lib, pkgs, ... }:

let
  cfg = config.programs.chromium;

  defaultProfile = lib.filterAttrs (_: v: v != null) {
    HomepageLocation = cfg.homepageLocation;
    DefaultSearchProviderEnabled = cfg.defaultSearchProviderEnabled;
    DefaultSearchProviderSearchURL = cfg.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfg.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = cfg.extensions;
  };

  mergedExtraOpts = browserPolicies // cfg.extraOpts;
  browserPolicies = cfg.policies.chromium or { };

  chromiumEtcConfig = {
    # Plasma integration
    "chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json" =
      lib.mkIf (cfg.enablePlasmaBrowserIntegration) {
        source = "${cfg.plasmaBrowserIntegrationPackage}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
      };

    # Managed policy files
    "chromium/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
      text = builtins.toJSON defaultProfile;
    };

    "chromium/policies/managed/extra.json" = lib.mkIf (mergedExtraOpts != { }) {
      text = builtins.toJSON mergedExtraOpts;
    };

    # First-run preferences
    "chromium/initial_preferences" = lib.mkIf (cfg.initialPrefs != { }) {
      text = builtins.toJSON cfg.initialPrefs;
    };
  };
in
{
  disabledModules = [ "programs/chromium.nix" ];

  options.programs.chromium = {
    enable = lib.mkEnableOption "Enable Chromium browser";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.chromium;
      description = "Chromium browser package to install.";
      defaultText = lib.literalExpression "pkgs.chromium";
    };

    enablePlasmaBrowserIntegration = lib.mkEnableOption "Native Messaging Host for Plasma Browser Integration";

    plasmaBrowserIntegrationPackage = lib.mkPackageOption pkgs [
      "kdePackages"
      "plasma-browser-integration"
    ] { };

    extensions = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      description = ''
        Chromium extension force-install list.
        Extension IDs come from Chrome Web Store URLs.
      '';
    };

    homepageLocation = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    defaultSearchProviderEnabled = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
    };

    defaultSearchProviderSearchURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    defaultSearchProviderSuggestURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    extraOpts = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional Chromium enterprise policy settings.";
    };

    initialPrefs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Initial (first-run) Chromium preferences.";
    };

    policies = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = { };
      description = "Browser-specific policy tree (Chromium only).";
      example = { chromium = { SyncDisabled = true; }; };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = chromiumEtcConfig;
      systemPackages = [ cfg.package ];
    };
  };
}

