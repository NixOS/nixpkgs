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

in {
  options.programs.firefox = {
    enable = mkEnableOption (mdDoc "the Firefox web browser");

    package = mkOption {
      description = mdDoc "Firefox package to use.";
      type = types.package;
      default = pkgs.firefox;
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
      description = mdDoc ''
        Group policies to install.

        See [Mozilla's documentation](https://github.com/mozilla/policy-templates/blob/master/README.md")
        for a list of available options.

        This can be used to install extensions declaratively! Check out the
        documentation of the `ExtensionSettings` policy for details.

        ${organisationInfo}
      '';
      type = policyFormat.type;
      default = {};
    };

    preferences = mkOption {
      description = mdDoc ''
        Preferences to set from `about://config`.

        Some of these might be able to be configured more ergonomically
        using policies.

        ${organisationInfo}
      '';
      type = with types; attrsOf (oneOf [ bool int string ]);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit (cfg) policies; };
      in
      mkIf (cfg.policies != { }) {
        "firefox/policies/policies.json".source = "${policiesJSON}";
      };

    # Preferences are converted into a policy
    programs.firefox.policies =
      mkIf (cfg.preferences != {})
      {
        Preferences = (mapAttrs (name: value: {
          Value = value;
          Status = "locked";
        }) cfg.preferences);
      };
  };

  meta.maintainers = with maintainers; [ danth ];
}
