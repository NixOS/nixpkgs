{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.chromium;

  defaultProfile = lib.filterAttrs (k: v: v != null) {
    HomepageLocation = cfg.homepageLocation;
    DefaultSearchProviderEnabled = cfg.defaultSearchProviderEnabled;
    DefaultSearchProviderSearchURL = cfg.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfg.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = cfg.extensions;
  };

  browserType =
    if cfg.package == null then
      null
    else
      let
        packageName = cfg.package.pname or (builtins.baseNameOf cfg.package);
      in
      lib.optionalString (lib.hasPrefix "google-chrome" packageName) "chrome"
      ++ lib.optionalString (lib.hasPrefix "brave-browser" packageName) "brave"
      ++ lib.optionalString (
        lib.hasPrefix "ungoogled-chromium" packageName || lib.hasPrefix "chromium" packageName
      ) "chromium";

  browserEtcConfig = {
    chromium = {
      "chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json" =
        lib.mkIf (cfg.enablePlasmaBrowserIntegration)
          {
            source = "${cfg.plasmaBrowserIntegrationPackage}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
          };
      "chromium/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
        text = builtins.toJSON defaultProfile;
      };
      "chromium/policies/managed/extra.json" = lib.mkIf (mergedExtraOpts != { }) {
        text = builtins.toJSON mergedExtraOpts;
      };
      "chromium/initial_preferences" = lib.mkIf (cfg.initialPrefs != { }) {
        text = builtins.toJSON cfg.initialPrefs;
      };
    };

    chrome = {
      "opt/chrome/native-messaging-hosts/org.kde.plasma.browser_integration.json" =
        lib.mkIf (cfg.enablePlasmaBrowserIntegration)
          {
            source = "${cfg.plasmaBrowserIntegrationPackage}/etc/opt/chrome/native-messaging-hosts/org.kde.plasma.browser_integration.json";
          };
      "opt/chrome/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
        text = builtins.toJSON defaultProfile;
      };
      "opt/chrome/policies/managed/extra.json" = lib.mkIf (mergedExtraOpts != { }) {
        text = builtins.toJSON mergedExtraOpts;
      };
    };

    brave = {
      "brave/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
        text = builtins.toJSON defaultProfile;
      };
      "brave/policies/managed/extra.json" = lib.mkIf (mergedExtraOpts != { }) {
        text = builtins.toJSON mergedExtraOpts;
      };
    };
  };

  mergedExtraOpts = browserPolicies // cfg.extraOpts;
  browserPolicies = cfg.policies.${browserType} or { };
  selectedBrowserConfig = browserEtcConfig.${browserType} or { };
in

{
  ###### interface

  options = {
    programs.chromium = {
      enable = lib.mkEnableOption "Enable Chrome or Chromium browser";

      # Intentionally set to `null` in order to keep the old behaviour
      package = lib.mkOption {
        type = lib.types.package;
        default = null;
        description = "Chromium browser package to install, `programs.chromium.enable` must be `true`.";
        defaultText = lib.literalExpression "pkgs.chromium";
        relatedPackages = [
          "brave"
          "ungoogled-chromium"
        ];
      };

      enablePlasmaBrowserIntegration = lib.mkEnableOption "Native Messaging Host for Plasma Browser Integration";

      plasmaBrowserIntegrationPackage = lib.mkPackageOption pkgs [
        "plasma5Packages"
        "plasma-browser-integration"
      ] { };

      extensions = lib.mkOption {
        type = with lib.types; nullOr (listOf str);
        description = ''
          List of chromium extensions to install.
          For list of plugins ids see id in url of extensions on
          [chrome web store](https://chrome.google.com/webstore/category/extensions)
          page. To install a chromium extension not included in the chrome web
          store, append to the extension id a semicolon ";" followed by a URL
          pointing to an Update Manifest XML file. See
          [ExtensionInstallForcelist](https://cloud.google.com/docs/chrome-enterprise/policies/?policy=ExtensionInstallForcelist)
          for additional details.
        '';
        default = null;
        example = lib.literalExpression ''
          [
            "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
            "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
            "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
          ]
        '';
      };

      homepageLocation = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Chromium default homepage";
        default = null;
        example = "https://nixos.org";
      };

      defaultSearchProviderEnabled = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        description = "Enable the default search provider.";
        default = null;
        example = true;
      };

      defaultSearchProviderSearchURL = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Chromium default search provider url.";
        default = null;
        example = "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
      };

      defaultSearchProviderSuggestURL = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Chromium default search provider url for suggestions.";
        default = null;
        example = "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
      };

      extraOpts = lib.mkOption {
        type = lib.types.attrs;
        description = ''
          Extra chromium policy options. A list of available policies
          can be found in the Chrome Enterprise documentation:
          <https://cloud.google.com/docs/chrome-enterprise/policies/>
          Make sure the selected policy is supported on Linux and your browser version.
        '';
        default = { };
        example = lib.literalExpression ''
          {
            "BrowserSignin" = 0;
            "SyncDisabled" = true;
            "PasswordManagerEnabled" = false;
            "SpellcheckEnabled" = true;
            "SpellcheckLanguage" = [
              "de"
              "en-US"
            ];
          }
        '';
      };

      initialPrefs = lib.mkOption {
        type = lib.types.attrs;
        description = ''
          Initial preferences are used to configure the browser for the first run.
          Unlike {option}`programs.chromium.extraOpts`, initialPrefs can be changed by users in the browser settings.
          More information can be found in the Chromium documentation:
          <https://www.chromium.org/administrators/configuring-other-preferences/>
        '';
        default = { };
        example = lib.literalExpression ''
          {
            "first_run_tabs" = [
              "https://nixos.org/"
            ];
          }
        '';
      };

      policies = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrs);
        default = { };
        description = "Browser-specific policies.";
        example = lib.literalExpression ''
          {
            chrome = {
              BrowserSignin = 0;
            };
            chromium = {
              SyncDisabled = true;
            };
            brave = {
              HomepageLocation = "https://brave.com/";
            };
          }
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment = {
      etc = selectedBrowserConfig;

      systemPackages = lib.optionals (cfg.package != null) [ cfg.package ];
    };
  };
}
