{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.openvpn3;
in
{
  options.programs.openvpn3 = {
    enable = mkEnableOption "the openvpn3 client";
  };

  config = mkIf cfg.enable {
    services.dbus.packages = with pkgs; [
      openvpn3
    ];

    users.users.openvpn = {
      isSystemUser = true;
      uid = config.ids.uids.openvpn;
      group = "openvpn";
    };

    users.groups.openvpn = {
      gid = config.ids.gids.openvpn;
    };

    environment.systemPackages = with pkgs; [
      openvpn3
    ];
  };

}
