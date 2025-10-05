{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.passSecretService;
in
{
  options.services.passSecretService = {
    enable = lib.mkEnableOption "pass secret service";

    package = lib.mkPackageOption pkgs "pass-secret-service" {
      example = "pass-secret-service.override { python3 = pkgs.python310 }";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ aidalgol ];
}
