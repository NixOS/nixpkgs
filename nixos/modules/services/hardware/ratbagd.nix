{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ratbagd;
in
{
  ###### interface

  options = {
    services.ratbagd = {
      enable = mkEnableOption (lib.mdDoc "ratbagd for configuring gaming mice");

      package = mkPackageOption pkgs "libratbag" { };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    # Give users access to the "ratbagctl" tool
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
