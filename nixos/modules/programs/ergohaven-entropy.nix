{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.entropy;
in
{
  options.programs.entropy = {
    enable = mkEnableOption "Entropy keyboard configurator";

    enableVialUdevRules = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Install udev rules for Vial-compatible HID device access.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.plugdev = { };

    environment.systemPackages = [ pkgs.entropy ];

    services.udev.packages = optionals cfg.enableVialUdevRules [ pkgs.entropy ];
  };
}
