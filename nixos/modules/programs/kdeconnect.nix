{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.eliasp ];

  options = {
    programs.kdeconnect = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable KDE Connect and configure the firewall for it.";
      };
    };
  };

  config = mkIf config.programs.kdeconnect.enable {
    environment.systemPackages = [ pkgs.kdeconnect ];
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };
}
