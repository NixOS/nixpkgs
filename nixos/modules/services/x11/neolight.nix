{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.xserver.xkb.neolight;
in
{
  options.services.xserver.xkb.neolight = {
    package = lib.mkPackageOption pkgs "neolight" { };
    enable = lib.mkEnableOption "neolight xkb layout, extra keyboard layers for programming based on Neo";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.sessionVariables.XKB_CONFIG_ROOT = lib.mkForce "${cfg.package}/share/X11/xkb";

    assertions = [
      {
        assertion = config.services.xserver.xkb.extraLayouts == { };
        message = "Neolight conflicts with xkb.extraLayouts";
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [ drafolin ];
}
