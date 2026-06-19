mkFirefoxBaseModule:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.firefox;
  baseModule = mkFirefoxBaseModule {
    variant = "firefox";
    prettyName = "Firefox";
    defaultPackage = pkgs.firefox;
    relatedPackages = [
      "firefox"
      "firefox-bin"
      "firefox-esr"
    ];
  };
in
{
  imports = [
    baseModule
  ]
  ++
    lib.mapAttrsToList
      (
        name: pkg:
        lib.mkRemovedOptionModule [
          "programs"
          "firefox"
          "nativeMessagingHosts"
          name
        ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.${pkg} ]` instead"
      )
      {
        browserpass = "browserpass";
        bukubrow = "bukubrow";
        euwebid = "web-eid-app";
        ff2mpv = "ff2mpv";
        fxCast = "fx-cast-bridge";
        gsconnect = "gnomeExtensions.gsconnect";
        jabref = "jabref";
        passff = "passff-host";
        tridactyl = "tridactyl-native";
        ugetIntegrator = "uget-integrator";
      };

  options = {
    programs.firefox = {

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
    };
  };

  config = {
    programs.firefox = {
      policies = {
        ExtensionSettings = builtins.listToAttrs (
          map (
            lang:
            lib.attrsets.nameValuePair "langpack-${lang}@firefox.mozilla.org" {
              installation_mode = "normal_installed";
              install_url = "https://releases.mozilla.org/pub/firefox/releases/${cfg.package.version}/linux-x86_64/xpi/${lang}.xpi";
            }
          ) cfg.languagePacks
        );
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    danth
    linsui
  ];
}
