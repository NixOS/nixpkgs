{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.alvr;
in
{
  options = {
    programs.alvr = {
      enable = mkEnableOption "ALVR, the VR desktop streamer";

      package = mkPackageOption pkgs "alvr" { };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the default ports in the firewall for the ALVR server.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9943 9944 ];
      allowedUDPPorts = [ 9943 9944 ];
    };
  };

  meta.maintainers = with maintainers; [ passivelemon ];
}
