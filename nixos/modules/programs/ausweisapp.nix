{ config, lib, pkgs, ... }:

with lib;

let
  cfg  = config.programs.ausweisapp;
in
{
  options.programs.ausweisapp = {
    enable = mkEnableOption (lib.mdDoc "AusweisApp2");

    openFirewall = mkOption {
      description = lib.mdDoc ''
        Whether to open the required firewall ports for the Smartphone as Card Reader (SaC) functionality of AusweisApp2.
      '';
      default = false;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ AusweisApp2 ];
    networking.firewall.allowedUDPPorts = lib.optionals cfg.openFirewall [ 24727 ];
  };
}
