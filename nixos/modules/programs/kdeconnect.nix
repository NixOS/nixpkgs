{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.programs.kdeconnect;

in
{
  options.programs.kdeconnect = {
    enable = mkOption {
      description = ''
        KDE Connect provides several features to integrate your phone and your computer.
        Enabling KDE Connect will install it and open the required UDP and TCP ports.
      '';
      default = false;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kdeconnect ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  };
}
