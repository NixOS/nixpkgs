{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.entropy;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionals
    ;
  inherit (lib.types) bool;
in
{
  options.programs.entropy = {
    enable = mkEnableOption "Entropy keyboard configurator";

    enableVialUdevRules = mkOption {
      type = bool;
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
