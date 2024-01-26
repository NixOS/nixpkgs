{ config, lib, pkgs, ... }:

with lib;

let
  cfg  = config.programs.ausweisapp;
in
{
  options.programs.ausweisapp = {
    enable = mkEnableOption (lib.mdDoc "AusweisApp");

    openFirewall = mkOption {
      description = lib.mdDoc ''
        Whether to open the required firewall ports for the Smartphone as Card Reader (SaC) functionality of AusweisApp.
      '';
      default = false;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ausweisapp ];
    networking.firewall.allowedUDPPorts = lib.optionals cfg.openFirewall [ 24727 ];
  };
}
