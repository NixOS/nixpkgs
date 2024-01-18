{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.kdeconnect = {
    enable = mkEnableOption (lib.mdDoc ''
      kdeconnect.

      Note that it will open the TCP and UDP port from
      1714 to 1764 as they are needed for it to function properly.
      You can use the {option}`package` to use
      `gnomeExtensions.gsconnect` as an alternative
      implementation if you use Gnome
    '');
    package = mkPackageOption pkgs [ "plasma5Packages" "kdeconnect-kde" ] {
      example = "gnomeExtensions.gsconnect";
    };
  };
  config =
    let
      cfg = config.programs.kdeconnect;
    in
      mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
        networking.firewall = rec {
          allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
          allowedUDPPortRanges = allowedTCPPortRanges;
        };
      };
}
