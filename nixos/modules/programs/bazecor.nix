{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.bazecor;
in
{
  meta.maintainers = with lib.maintainers; [ amesgen ];

  options = {
    programs.bazecor = {
      enable = lib.mkEnableOption "Bazecor, the graphical configurator for Dygma Products";
      package = lib.mkPackageOption pkgs "bazecor" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
