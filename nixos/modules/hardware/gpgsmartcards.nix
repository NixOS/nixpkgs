{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.gpgSmartcards;
in
{
  options.hardware.gpgSmartcards = {
    enable = lib.mkEnableOption "udev rules for gnupg smart cards";

    package = lib.mkPackageOption pkgs "scdaemon-udev-rules-debian" { };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
