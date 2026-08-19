{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.thunderbird;
  policyFormat = pkgs.formats.json { };
  policyDoc = "https://github.com/thunderbird/policy-templates";
in
{
  options.programs.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird mail client";

    package = lib.mkPackageOption pkgs "thunderbird" { };

    policies = lib.mkOption {
      type = policyFormat.type;
      default = { };
      description = ''
        Group policies to install.

        See [Thunderbird's documentation](${policyDoc})
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.

      '';
    };

    preferences = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          int
          str
        ]);
      default = { };
      description = ''
        Preferences to set from `about:config`.

        Some of these might be able to be configured more ergonomically
        using policies.
      '';
    };

    preferencesStatus = lib.mkOption {
      type = lib.types.enum [
        "default"
        "locked"
        "user"
        "clear"
      ];
      default = "locked";
      description = ''
        The status of `thunderbird.preferences`.

        `status` can assume the following values:
        - `"default"`: Preferences appear as default.
        - `"locked"`: Preferences appear as default and can't be changed.
        - `"user"`: Preferences appear as changed.
        - `"clear"`: Value has no effect. Resets to factory defaults on each startup.
      '';
    };

    languagePacks = lib.mkOption {
      # Available languages can be found in https://releases.mozilla.org/pub/thunderbird/releases/${cfg.package.version}/linux-x86_64/xpi/
      type = lib.types.listOf (
        lib.types.enum ([
          "af"
          "ar"
          "ast"
          "be"
          "bg"
          "br"
          "ca"
          "cak"
          "cs"
          "cy"
          "da"
          "de"
          "dsb"
          "el"
          "en-CA"
          "en-GB"
          "en-US"
          "es-AR"
          "es-ES"
          "es-MX"
          "et"
          "eu"
          "fi"
          "fr"
          "fy-NL"
          "ga-IE"
          "gd"
          "gl"
          "he"
          "hr"
          "hsb"
          "hu"
          "hy-AM"
          "id"
          "is"
          "it"
          "ja"
          "ka"
          "kab"
          "kk"
          "ko"
          "lt"
          "lv"
          "ms"
          "nb-NO"
          "nl"
          "nn-NO"
          "pa-IN"
          "pl"
          "pt-BR"
          "pt-PT"
          "rm"
          "ro"
          "ru"
          "sk"
          "sl"
          "sq"
          "sr"
          "sv-SE"
          "th"
          "tr"
          "uk"
          "uz"
          "vi"
          "zh-CN"
          "zh-TW"
        ])
      );
      default = [ ];
      description = ''
        The language packs to install.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "thunderbird-policies.json" { inherit (cfg) policies; };
      in
      lib.mkIf (cfg.policies != { }) { "thunderbird/policies/policies.json".source = policiesJSON; };

    programs.thunderbird.policies = {
      DisableAppUpdate = true;
      Preferences = builtins.mapAttrs (_: value: {
        Value = value;
        Status = cfg.preferencesStatus;
      }) cfg.preferences;
      ExtensionSettings = builtins.listToAttrs (
        builtins.map (
          lang:
          lib.attrsets.nameValuePair "langpack-${lang}@thunderbird.mozilla.org" {
            installation_mode = "normal_installed";
            install_url = "https://releases.mozilla.org/pub/thunderbird/releases/${cfg.package.version}/linux-x86_64/xpi/${lang}.xpi";
          }
        ) cfg.languagePacks
      );
    };
  };

  meta.maintainers = with lib.maintainers; [ nydragon ];
}
