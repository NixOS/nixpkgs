{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.passSecretService;
in
{
  options.services.passSecretService = {
    enable = mkEnableOption "pass secret service";

    package = mkOption {
      type = types.package;
      default = pkgs.pass-secret-service;
      defaultText = literalExpression "pkgs.pass-secret-service";
      description = "Which pass-secret-service package to use.";
      example = literalExpression "pkgs.pass-secret-service.override { python3 = pkgs.python310 }";
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [ aidalgol ];
}
