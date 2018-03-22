{ config, lib, ... }:

with lib;

let
  cfg = config.programs.chromium;

  defaultProfile = filterAttrs (k: v: v != null) {
    HomepageLocation = cfg.homepageLocation;
    DefaultSearchProviderSearchURL = cfg.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfg.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = map (extension:
      "${extension};https://clients2.google.com/service/update2/crx"
    ) cfg.extensions;
  };
in

{
  ###### interface

  options = {
    programs.chromium = {
      enable = mkEnableOption "<command>chromium</command> policies";

      extensions = mkOption {
        type = types.listOf types.str;
        description = ''
          List of chromium extensions to install.
          For list of plugins ids see id in url of extensions on
          <link xlink:href="https://chrome.google.com/webstore/category/extensions">chrome web store</link>
          page.
        '';
        default = [];
        example = literalExample ''
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
        description = "Chromium default homepage";
        default = null;
        example = "https://nixos.org";
      };

      defaultSearchProviderSearchURL = mkOption {
        type = types.nullOr types.str;
        description = "Chromium default search provider url.";
        default = null;
        example =
          "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
      };

      defaultSearchProviderSuggestURL = mkOption {
        type = types.nullOr types.str;
        description = "Chromium default search provider url for suggestions.";
        default = null;
        example =
          "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
      };

      extraOpts = mkOption {
        type = types.attrs;
        description = ''
          Extra chromium policy options, see
          <link xlink:href="https://www.chromium.org/administrators/policy-list-3">https://www.chromium.org/administrators/policy-list-3</link>
          for a list of avalible options
        '';
        default = {};
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
  };
}
