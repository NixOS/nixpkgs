{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.entropy;
  inherit (lib) mkIf;
in
{
  options.programs.entropy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables the Entropy keyboard configurator and sets up necessary
        udev rules for Vial-QMK/RMK compatible devices.
        This allows configuring programmable keyboards without root privileges.
        Ensure your user is a member of the 'plugdev' group after enabling.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.plugdev = { };

    environment.systemPackages = [ pkgs.ergohaven-entropy ];

    services.udev.packages = [ pkgs.ergohaven-entropy ];

    i18n.inputMethod.ibus.engines = [ pkgs.ergohaven-entropy ];
  };
}
