{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.passSecretService;
in
{
  options.services.passSecretService = {
    enable = mkEnableOption "pass secret service";

    package = mkPackageOption pkgs "pass-secret-service" {
      example = "pass-secret-service.override { python3 = pkgs.python310 }";
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [ aidalgol ];
}
