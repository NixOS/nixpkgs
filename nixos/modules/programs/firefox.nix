{ pkgs, config, lib, ... }:

with lib;

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
    enable = mkEnableOption (mdDoc "the Firefox web browser");

    package = mkOption {
      type = types.package;
      default = pkgs.firefox;
      description = mdDoc "Firefox package to use.";
      defaultText = literalExpression "pkgs.firefox";
      relatedPackages = [
        "firefox"
        "firefox-beta-bin"
        "firefox-bin"
        "firefox-devedition-bin"
        "firefox-esr"
      ];
    };

    wrapperConfig = mkOption {
      type = types.attrs;
      default = {};
      description = mdDoc "Arguments to pass to Firefox wrapper";
    };

    policies = mkOption {
      type = policyFormat.type;
      default = { };
      description = mdDoc ''
        Group policies to install.

        See [Mozilla's documentation](https://mozilla.github.io/policy-templates/)
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.

        ${organisationInfo}
      '';
    };

    preferences = mkOption {
      type = with types; attrsOf (oneOf [ bool int str ]);
      default = { };
      description = mdDoc ''
        Preferences to set from `about:config`.

        Some of these might be able to be configured more ergonomically
        using policies.

        ${organisationInfo}
      '';
    };

    preferencesStatus = mkOption {
      type = types.enum [ "default" "locked" "user" "clear" ];
      default = "locked";
      description = mdDoc ''
        The status of `firefox.preferences`.

        `status` can assume the following values:
        - `"default"`: Preferences appear as default.
        - `"locked"`: Preferences appear as default and can't be changed.
        - `"user"`: Preferences appear as changed.
        - `"clear"`: Value has no effect. Resets to factory defaults on each startup.
      '';
    };

    languagePacks = mkOption {
      # Available languages can be found in https://releases.mozilla.org/pub/firefox/releases/${cfg.package.version}/linux-x86_64/xpi/
      type = types.listOf (types.enum ([
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
        "sco"
        "si"
        "sk"
        "sl"
        "son"
        "sq"
        "sr"
        "sv-SE"
        "szl"
        "ta"
        "te"
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
      ]));
      default = [ ];
      description = mdDoc ''
        The language packs to install.
      '';
    };

    autoConfig = mkOption {
      type = types.lines;
      default = "";
      description = mdDoc ''
        AutoConfig files can be used to set and lock preferences that are not covered
        by the policies.json for Mac and Linux. This method can be used to automatically
        change user preferences or prevent the end user from modifiying specific
        preferences by locking them. More info can be found in https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig.
      '';
    };

    nativeMessagingHosts = ({
      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = mdDoc ''
          Additional packages containing native messaging hosts that should be made available to Firefox extensions.
        '';
      };
    }) // (mapAttrs (k: v: mkEnableOption (mdDoc "${v.name} support")) nmhOptions);
  };

  config = let
    forEachEnabledNmh = fn: flatten (mapAttrsToList (k: v: lib.optional cfg.nativeMessagingHosts.${k} (fn k v)) nmhOptions);
  in mkIf cfg.enable {
    warnings = forEachEnabledNmh (k: v:
      "The `programs.firefox.nativeMessagingHosts.${k}` option is deprecated, " +
      "please add `${v.package.pname}` to `programs.firefox.nativeMessagingHosts.packages` instead."
    );
    programs.firefox.nativeMessagingHosts.packages = forEachEnabledNmh (_: v: v.package);

    environment.systemPackages = [
      (cfg.package.override (old: {
        extraPrefsFiles = old.extraPrefsFiles or [] ++ [(pkgs.writeText "firefox-autoconfig.js" cfg.autoConfig)];
        nativeMessagingHosts = old.nativeMessagingHosts or [] ++ cfg.nativeMessagingHosts.packages;
        cfg = (old.cfg or {}) // cfg.wrapperConfig;
      }))
    ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit (cfg) policies; };
      in
      mkIf (cfg.policies != { }) {
        "firefox/policies/policies.json".source = "${policiesJSON}";
      };

    # Preferences are converted into a policy
    programs.firefox.policies = {
      Preferences = (mapAttrs
        (_: value: { Value = value; Status = cfg.preferencesStatus; })
        cfg.preferences);
      ExtensionSettings = listToAttrs (map
        (lang: nameValuePair
          "langpack-${lang}@firefox.mozilla.org"
          {
            installation_mode = "normal_installed";
            install_url = "https://releases.mozilla.org/pub/firefox/releases/${cfg.package.version}/linux-x86_64/xpi/${lang}.xpi";
          }
        )
        cfg.languagePacks);
    };
  };

  meta.maintainers = with maintainers; [ danth ];
}
