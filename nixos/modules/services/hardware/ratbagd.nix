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
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    # Give users access to the "ratbagctl" tool
    environment.systemPackages = [ pkgs.libratbag ];

    services.dbus.packages = [ pkgs.libratbag ];

    systemd.packages = [ pkgs.libratbag ];
  };
}
