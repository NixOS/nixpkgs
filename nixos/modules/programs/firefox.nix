{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.firefox;

  policyFormat = pkgs.formats.json { };

  organisationInfo = ''
    When this option is in use, Firefox will inform you that "your browser
    is managed by your organisation". That message appears because NixOS
    installs what you have declared here such that it cannot be overridden
    through the user interface. It does not mean that someone else has been
    given control of your browser, unless of course they also control your
    NixOS configuration.
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "browserpass"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.browserpass ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "bukubrow"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.bukubrow ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "euwebid"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.web-eid-app ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "ff2mpv"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.ff2mpv ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "fxCast"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.fx-cast-bridge ]` instead")
    (lib.mkRemovedOptionModule [ "programs" "firefox" "nativeMessagingHosts" "gsconnect" ]
      "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.gnomeExtensions.gsconnect ]` instead"
    )
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "jabref"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.jabref ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "passff"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.passff-host ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "tridactyl"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.tridactyl-native ]` instead")
    (lib.mkRemovedOptionModule [
      "programs"
      "firefox"
      "nativeMessagingHosts"
      "ugetIntegrator"
    ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.uget-integrator ]` instead")
  ];

  options.programs.firefox = {
    enable = lib.mkEnableOption "the Firefox web browser";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefox;
      description = "Firefox package to use.";
      defaultText = lib.literalExpression "pkgs.firefox";
      relatedPackages = [
        "firefox"
        "firefox-bin"
        "firefox-esr"
      ];
    };

    wrapperConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Arguments to pass to Firefox wrapper";
    };

    policies = lib.mkOption {
      type = policyFormat.type;
      default = { };
      description = ''
        Group policies to install.

        See [Mozilla's documentation](https://mozilla.github.io/policy-templates/)
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.

        ${organisationInfo}
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

        See [here](https://mozilla.github.io/policy-templates/#preferences) for allowed preferences.

        ${organisationInfo}
      '';
      example = lib.literalExpression ''
        {
          "browser.tabs.tabmanager.enabled" = false;
        }
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
        The status of `firefox.preferences`.

        `status` can assume the following values:
        - `"default"`: Preferences appear as default.
        - `"locked"`: Preferences appear as default and can't be changed.
        - `"user"`: Preferences appear as changed.
        - `"clear"`: Value has no effect. Resets to factory defaults on each startup.
      '';
    };

    languagePacks = lib.mkOption {
      # Available languages can be found in https://releases.mozilla.org/pub/firefox/releases/${cfg.package.version}/linux-x86_64/xpi/
      type = lib.types.listOf (
        lib.types.enum [
          "ach"
          "af"
          "an"
          "ar"
          "ast"
          "az"
          "be"
          "bg"
          "bn"
          "br"
          "bs"
          "ca-valencia"
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
          "eo"
          "es-AR"
          "es-CL"
          "es-ES"
          "es-MX"
          "et"
          "eu"
          "fa"
          "ff"
          "fi"
          "fr"
          "fur"
          "fy-NL"
          "ga-IE"
          "gd"
          "gl"
          "gn"
          "gu-IN"
          "he"
          "hi-IN"
          "hr"
          "hsb"
          "hu"
          "hy-AM"
          "ia"
          "id"
          "is"
          "it"
          "ja"
          "ka"
          "kab"
          "kk"
          "km"
          "kn"
          "ko"
          "lij"
          "lt"
          "lv"
          "mk"
          "mr"
          "ms"
          "my"
          "nb-NO"
          "ne-NP"
          "nl"
          "nn-NO"
          "oc"
          "pa-IN"
          "pl"
          "pt-BR"
          "pt-PT"
          "rm"
          "ro"
          "ru"
          "sat"
          "sc"
          "sco"
          "si"
          "sk"
          "skr"
          "sl"
          "son"
          "sq"
          "sr"
          "sv-SE"
          "szl"
          "ta"
          "te"
          "tg"
          "th"
          "tl"
          "tr"
          "trs"
          "uk"
          "ur"
          "uz"
          "vi"
          "xh"
          "zh-CN"
          "zh-TW"
        ]
      );
      default = [ ];
      description = ''
        The language packs to install.
      '';
    };

    autoConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        AutoConfig files can be used to set and lock preferences that are not covered
        by the policies.json for Mac and Linux. This method can be used to automatically
        change user preferences or prevent the end user from modifiying specific
        preferences by locking them. More info can be found in <https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig>.
      '';
    };

    autoConfigFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      description = ''
        AutoConfig files can be used to set and lock preferences that are not covered
        by the policies.json for Mac and Linux. This method can be used to automatically
        change user preferences or prevent the end user from modifiying specific
        preferences by locking them. More info can be found in <https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig>.

        Files are concated and autoConfig is appended.
      '';
    };

    nativeMessagingHosts.packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Additional packages containing native messaging hosts that should be made available to Firefox extensions.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.override (old: {
        extraPrefsFiles =
          old.extraPrefsFiles
          ++ cfg.autoConfigFiles
          ++ [ (pkgs.writeText "firefox-autoconfig.js" cfg.autoConfig) ];
        nativeMessagingHosts = old.nativeMessagingHosts ++ cfg.nativeMessagingHosts.packages;
        cfg = old.cfg // cfg.wrapperConfig;
      }))
    ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit (cfg) policies; };
      in
      lib.mkIf (cfg.policies != { }) {
        "firefox/policies/policies.json".source = "${policiesJSON}";
      };

    # Preferences are converted into a policy
    programs.firefox.policies = {
      DisableAppUpdate = true;
      Preferences = (
        builtins.mapAttrs (_: value: {
          Value = value;
          Status = cfg.preferencesStatus;
        }) cfg.preferences
      );
      ExtensionSettings = builtins.listToAttrs (
        builtins.map (
          lang:
          lib.attrsets.nameValuePair "langpack-${lang}@firefox.mozilla.org" {
            installation_mode = "normal_installed";
            install_url = "https://releases.mozilla.org/pub/firefox/releases/${cfg.package.version}/linux-x86_64/xpi/${lang}.xpi";
          }
        ) cfg.languagePacks
      );
    };
  };

  meta.maintainers = with lib.maintainers; [
    danth
    linsui
  ];
}
