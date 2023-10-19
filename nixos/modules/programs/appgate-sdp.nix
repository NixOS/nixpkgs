{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    programs.appgate-sdp = {
      enable = mkEnableOption (lib.mdDoc "AppGate SDP VPN client");
    };
  };

  config = mkIf config.programs.appgate-sdp.enable {
    boot.kernelModules = [ "tun" ];
    environment.systemPackages = [ pkgs.appgate-sdp ];
    services.dbus.packages = [ pkgs.appgate-sdp ];
    systemd = {
      packages = [ pkgs.appgate-sdp ];
      # https://github.com/NixOS/nixpkgs/issues/81138
      services.appgatedriver.wantedBy = [ "multi-user.target" ];
      services.appgate-dumb-resolver.path = [ pkgs.e2fsprogs ];
      services.appgate-resolver.path = [ pkgs.procps pkgs.e2fsprogs ];
      services.appgatedriver.path = [ pkgs.e2fsprogs ];
    };
  };
}
