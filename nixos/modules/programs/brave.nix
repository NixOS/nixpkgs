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

  braveEtcConfig = {
    # Managed (enterprise) policy files
    "brave/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
      text = builtins.toJSON defaultProfile;
    };

    "brave/policies/managed/extra.json" = lib.mkIf (cfg.policies != { }) {
      text = builtins.toJSON cfg.policies;
    };
  };

in
{
  options.programs.brave = {
    enable = lib.mkEnableOption "the Brave web browser";

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

    policies = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Additional Brave Enterprise policy settings.
        These follow the same format as Chromium policies:
        https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy
      '';
      example = {
        "SyncDisabled" = true;
        "MetricsReportingEnabled" = false;
        "BraveRewardsDisabled" = false;
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
