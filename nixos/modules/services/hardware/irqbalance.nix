#
{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance = {

    enable = lib.mkEnableOption "irqbalance daemon";

    package = lib.mkPackageOption pkgs "irqbalance" { };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.irqbalance.wantedBy = [ "multi-user.target" ];

    systemd.packages = [ cfg.package ];

  };

}
