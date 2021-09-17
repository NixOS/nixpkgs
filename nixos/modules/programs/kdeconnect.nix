{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.kdeconnect = {
    enable = mkEnableOption ''
      kdeconnect.

      Note that it will open the TCP and UDP port from
      1714 to 1764 as they are needed for it to function properly.
      You can use the <option>package</option> to use
      <code>gnomeExtensions.gsconnect</code> as an alternative
      implementation if you use Gnome.
    '';
    package = mkOption {
      default = pkgs.kdeconnect;
      defaultText = "pkgs.kdeconnect";
      type = types.package;
      example = literalExample "pkgs.gnomeExtensions.gsconnect";
      description = ''
        The package providing the implementation for kdeconnect.
      '';
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
