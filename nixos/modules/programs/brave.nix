{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.brave;

  defaultProfile = lib.filterAttrs (_: v: v != null) {
    HomepageLocation = cfg.homepageLocation;
    DefaultSearchProviderEnabled = cfg.defaultSearchProviderEnabled;
    DefaultSearchProviderSearchURL = cfg.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfg.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = cfg.extensions;
  };

  mergedExtraOpts = bravePolicies // cfg.extraOpts;
  bravePolicies = cfg.policies.brave or { };

  braveEtcConfig = {
    # Managed (enterprise) policy files
    "brave/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
      text = builtins.toJSON defaultProfile;
    };

    "brave/policies/managed/extra.json" = lib.mkIf (mergedExtraOpts != { }) {
      text = builtins.toJSON mergedExtraOpts;
    };

    # First-run initial preferences (optional)
    "brave/initial_preferences" = lib.mkIf (cfg.initialPrefs != { }) {
      text = builtins.toJSON cfg.initialPrefs;
    };
  };

in
{
  options.programs.brave = {
    enable = lib.mkEnableOption "Enable Brave browser";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.brave;
      description = "The Brave browser package to install.";
      defaultText = lib.literalExpression "pkgs.brave";
    };

    extensions = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      description = ''
        List of Brave (Chromium-style) extensions to force-install.
        These work the same way as Chromium extensions: a Chrome Web Store ID,
        optionally followed by `;url-to-update-manifest.xml`.
      '';
    };

    homepageLocation = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Brave default homepage.";
    };

    defaultSearchProviderEnabled = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Enable/disable default search provider.";
    };

    defaultSearchProviderSearchURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Search URL Brave should use as the default search provider.";
    };

    defaultSearchProviderSuggestURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Suggestion URL for Brave's default search provider.";
    };

    extraOpts = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Additional Brave Enterprise policy settings.
        These follow the same format as Chromium policies:
        https://support.brave.com/hc/en-us/articles/360045038951-Group-Policy-supported-features-for-Brave
      '';
    };

    initialPrefs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Initial (first-run) Brave preferences.
        Users may later override these in-browser.
      '';
    };

    policies = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = { };
      description = "Brave-specific policy tree (merged after extraOpts).";
      example = {
        brave = {
          "SyncDisabled" = true;
          "MetricsReportingEnabled" = false;
          "BrowserAddPersonEnabled" = false;
          "BraveRewardsDisabled" = false;
          "BraveVPNDisabled" = false;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = braveEtcConfig;
      systemPackages = [ cfg.package ];
    };
  };
}
