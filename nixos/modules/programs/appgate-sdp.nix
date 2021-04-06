{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.appgate-sdp;
in
{
  options = {
    programs.appgate-sdp = {
      enable = mkEnableOption
        "AppGate SDP VPN client";

      package = mkOption {
        type = types.package;
        default = pkgs.appgate-sdp;
        defaultText = "pkgs.appgate-sdp";
        description = "appgate-sdp package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd = {
      packages = [ cfg.package ];
      # https://github.com/NixOS/nixpkgs/issues/81138
      services.appgatedriver.wantedBy = [ "multi-user.target" ];
    };
  };
}
