{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.firefox;

  nmh = cfg.nativeMessagingHosts;

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
        "firefox-esr-wayland"
        "firefox-wayland"
      ];
    };

    policies = mkOption {
      type = policyFormat.type;
      default = { };
      description = mdDoc ''
        Group policies to install.

        See [Mozilla's documentation](https://github.com/mozilla/policy-templates/blob/master/README.md")
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.

        ${organisationInfo}
      '';
    };

    preferences = mkOption {
      type = with types; attrsOf (oneOf [ bool int string ]);
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

    nativeMessagingHosts = mapAttrs (_: v: mkEnableOption (mdDoc v)) {
      browserpass = "Browserpass support";
      bukubrow = "Bukubrow support";
      ff2mpv = "ff2mpv support";
      fxCast = "fx_cast support";
      gsconnect = "GSConnect support";
      jabref = "JabRef support";
      passff = "PassFF support";
      tridactyl = "Tridactyl support";
      ugetIntegrator = "Uget Integrator support";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.override {
        extraPrefs = cfg.autoConfig;
        extraNativeMessagingHosts = with pkgs; optionals nmh.ff2mpv [
          ff2mpv
        ] ++ optionals nmh.gsconnect [
          gnomeExtensions.gsconnect
        ] ++ optionals nmh.jabref [
          jabref
        ] ++ optionals nmh.passff [
          passff-host
        ];
      })
    ];

    nixpkgs.config.firefox = {
      enableBrowserpass = nmh.browserpass;
      enableBukubrow = nmh.bukubrow;
      enableTridactylNative = nmh.tridactyl;
      enableUgetIntegrator = nmh.ugetIntegrator;
      enableFXCastBridge = nmh.fxCast;
    };

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit (cfg) policies; };
      in
      mkIf (cfg.policies != { }) {
        "firefox/policies/policies.json".source = "${policiesJSON}";
      };

    # Preferences are converted into a policy
    programs.firefox.policies = mkIf (cfg.preferences != { }) {
      Preferences = (mapAttrs
        (_: value: { Value = value; Status = cfg.preferencesStatus; })
        cfg.preferences);
    };
  };

  meta.maintainers = with maintainers; [ danth ];
}
