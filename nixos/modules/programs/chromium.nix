{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.chromium;

  defaultProfile = lib.filterAttrs (_: v: v != null) {
    ExtensionInstallForcelist = cfg.extensions;
  };

  chromiumEtcConfig = {
    # Plasma integration
    "chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json" =
      lib.mkIf (cfg.enablePlasmaBrowserIntegration)
        {
          source = "${cfg.plasmaBrowserIntegrationPackage}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
        };

    # Managed policy files
    "chromium/policies/managed/default.json" = lib.mkIf (defaultProfile != { }) {
      text = builtins.toJSON defaultProfile;
    };

    "chromium/policies/managed/extra.json" = lib.mkIf (cfg.policies != { }) {
      text = builtins.toJSON cfg.policies;
    };

    # First-run preferences
    "chromium/initial_preferences" = lib.mkIf (cfg.initialPrefs != { }) {
      text = builtins.toJSON cfg.initialPrefs;
    };
  };
in
{
  disabledModules = [ "programs/chromium.nix" ];

  options.programs.chromium = {
    enable = lib.mkEnableOption "Enable Chromium browser";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.chromium;
      description = "Chromium browser package to install.";
      defaultText = lib.literalExpression "pkgs.chromium";
    };

    enablePlasmaBrowserIntegration = lib.mkEnableOption "Native Messaging Host for Plasma Browser Integration";

    plasmaBrowserIntegrationPackage = lib.mkPackageOption pkgs [
      "kdePackages"
      "plasma-browser-integration"
    ] { };

    extensions = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      description = ''
        Chromium extension force-install list.
        Extension IDs come from Chrome Web Store URLs.
      '';
    };

    initialPrefs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Initial (first-run) Chromium preferences.";
    };

    policies = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Browser-specific policy tree (Chromium only).";
      example = {
        SyncDisabled = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = chromiumEtcConfig;
      systemPackages = [ cfg.package ];
    };
  };
}
