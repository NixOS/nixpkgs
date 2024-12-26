{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption;
  cfg = config.services.eg25-manager;
in
{
  options.services.eg25-manager = {
    enable = mkEnableOption "Quectel EG25 modem manager service";

    package = mkPackageOption pkgs "eg25-manager" { };
  };
  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    systemd.services.eg25-manager.wantedBy = [ "multi-user.target" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
