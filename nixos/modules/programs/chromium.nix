{ config, lib, ... }:

with lib;

let
  cfg = config.programs.chromium;

  defaultProfile = filterAttrs (k: v: v != null) {
    HomepageLocation = cfg.homepageLocation;
    DefaultSearchProviderEnabled = cfg.defaultSearchProviderEnabled;
    DefaultSearchProviderSearchURL = cfg.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfg.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = cfg.extensions;
  };
in

{
  ###### interface

  options = {
    programs.chromium = {
      enable = mkEnableOption "<command>chromium</command> policies";

      extensions = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of chromium extensions to install.
          For list of plugins ids see id in url of extensions on
          [chrome web store](https://chrome.google.com/webstore/category/extensions)
          page. To install a chromium extension not included in the chrome web
          store, append to the extension id a semicolon ";" followed by a URL
          pointing to an Update Manifest XML file. See
          [ExtensionInstallForcelist](https://cloud.google.com/docs/chrome-enterprise/policies/?policy=ExtensionInstallForcelist)
          for additional details.
        '';
        default = [];
        example = literalExpression ''
          [
            "chlffgpmiacpedhhbkiomidkjlcfhogd" # pushbullet
            "mbniclmhobmnbdlbpiphghaielnnpgdp" # lightshot
            "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
          ]
        '';
      };

      homepageLocation = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "Chromium default homepage";
        default = null;
        example = "https://nixos.org";
      };

      defaultSearchProviderEnabled = mkOption {
        type = types.nullOr types.bool;
        description = lib.mdDoc "Enable the default search provider.";
        default = null;
        example = true;
      };

      defaultSearchProviderSearchURL = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "Chromium default search provider url.";
        default = null;
        example =
          "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
      };

      defaultSearchProviderSuggestURL = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "Chromium default search provider url for suggestions.";
        default = null;
        example =
          "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
      };

      extraOpts = mkOption {
        type = types.attrs;
        description = lib.mdDoc ''
          Extra chromium policy options. A list of available policies
          can be found in the Chrome Enterprise documentation:
          <https://cloud.google.com/docs/chrome-enterprise/policies/>
          Make sure the selected policy is supported on Linux and your browser version.
        '';
        default = {};
        example = literalExpression ''
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
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    # for chromium
    environment.etc."chromium/policies/managed/default.json".text = builtins.toJSON defaultProfile;
    environment.etc."chromium/policies/managed/extra.json".text = builtins.toJSON cfg.extraOpts;
    # for google-chrome https://www.chromium.org/administrators/linux-quick-start
    environment.etc."opt/chrome/policies/managed/default.json".text = builtins.toJSON defaultProfile;
    environment.etc."opt/chrome/policies/managed/extra.json".text = builtins.toJSON cfg.extraOpts;
    # for brave
    environment.etc."brave/policies/managed/default.json".text = builtins.toJSON defaultProfile;
    environment.etc."brave/policies/managed/extra.json".text = builtins.toJSON cfg.extraOpts;
  };
}
