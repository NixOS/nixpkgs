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

  # deprecated per-native-messaging-host options
  nmhOptions = {
    browserpass = {
      name = "Browserpass";
      package = pkgs.browserpass;
    };
    bukubrow = {
      name = "Bukubrow";
      package = pkgs.bukubrow;
    };
    euwebid = {
      name = "Web eID";
      package = pkgs.web-eid-app;
    };
    ff2mpv = {
      name = "ff2mpv";
      package = pkgs.ff2mpv;
    };
    fxCast = {
      name = "fx_cast";
      package = pkgs.fx-cast-bridge;
    };
    gsconnect = {
      name = "GSConnect";
      package = pkgs.gnomeExtensions.gsconnect;
    };
    jabref = {
      name = "JabRef";
      package = pkgs.jabref;
    };
    passff = {
      name = "PassFF";
      package = pkgs.passff-host;
    };
    tridactyl = {
      name = "Tridactyl";
      package = pkgs.tridactyl-native;
    };
    ugetIntegrator = {
      name = "Uget Integrator";
      package = pkgs.uget-integrator;
    };
  };
in
{
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

    nativeMessagingHosts = {
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Additional packages containing native messaging hosts that should be made available to Firefox extensions.
        '';
      };
    }
    // (builtins.mapAttrs (k: v: lib.mkEnableOption "${v.name} support") nmhOptions);
  };

  config =
    let
      forEachEnabledNmh =
        fn:
        lib.flatten (
          lib.mapAttrsToList (k: v: lib.optional cfg.nativeMessagingHosts.${k} (fn k v)) nmhOptions
        );
    in
    lib.mkIf cfg.enable {
      warnings = forEachEnabledNmh (
        k: v:
        "The `programs.firefox.nativeMessagingHosts.${k}` option is deprecated, "
        + "please add `${v.package.pname}` to `programs.firefox.nativeMessagingHosts.packages` instead."
      );
      programs.firefox.nativeMessagingHosts.packages = forEachEnabledNmh (_: v: v.package);

      environment.systemPackages = [
        (cfg.package.override (old: {
          extraPrefsFiles =
            old.extraPrefsFiles or [ ]
            ++ cfg.autoConfigFiles
            ++ [ (pkgs.writeText "firefox-autoconfig.js" cfg.autoConfig) ];
          nativeMessagingHosts = lib.unique (
            old.nativeMessagingHosts or [ ] ++ cfg.nativeMessagingHosts.packages
          );
          cfg = (old.cfg or { }) // cfg.wrapperConfig;
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
