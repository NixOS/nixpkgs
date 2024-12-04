{ config, pkgs, lib, ... }:

let
  cfg = config.programs.alvr;
in
{
  options = {
    programs.alvr = {
      enable = lib.mkEnableOption "ALVR, the VR desktop streamer";

      package = lib.mkPackageOption pkgs "alvr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the default ports in the firewall for the ALVR server.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9943 9944 ];
      allowedUDPPorts = [ 9943 9944 ];
    };
  };

  meta.maintainers = with lib.maintainers; [ passivelemon ];
}
