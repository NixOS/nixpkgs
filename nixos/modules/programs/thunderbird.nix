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
    };
  };

  meta.maintainers = with lib.maintainers; [ nydragon ];
}
