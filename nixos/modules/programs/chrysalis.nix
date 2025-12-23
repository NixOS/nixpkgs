{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.chrysalis;
in
{
  options = {
    programs.chrysalis = {
      enable = lib.mkEnableOption "Chrysalis";
      package = lib.mkPackageOption pkgs "Chrysalis" { default = "chrysalis"; };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ atalii ];
}
