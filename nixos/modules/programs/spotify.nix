{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.spotify;

  localDiscoveryPort = 57621;
in
{
  options.programs.spotify = {
    enable = mkEnableOption ''
      The first party client for the Spotify music streaming service.
    '';

    package = mkOption {
      type = types.package;
      default = pkgs.spotify;
      defaultText = "pkgs.spotify";
      description = ''
        The Spotify client package to be used.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Needed to sync local tracks with devices in the LAN.
    networking.firewall.allowedTCPPorts = [ localDiscoveryPort ];
  };
}
