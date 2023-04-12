{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.programs.mosh;

in
{
  options.programs.mosh = {
    enable = mkOption {
      description = lib.mdDoc ''
        Whether to enable mosh. Note, this will open ports in your firewall!
      '';
      default = false;
      type = lib.types.bool;
    };
    withUtempter = mkOption {
      description = lib.mdDoc ''
        Whether to enable libutempter for mosh.
        This is required so that mosh can write to /var/run/utmp (which can be queried with `who` to display currently connected user sessions).
        Note, this will add a guid wrapper for the group utmp!
      '';
      default = true;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mosh ];
    networking.firewall.allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
    security.wrappers = mkIf cfg.withUtempter {
      utempter = {
        source = "${pkgs.libutempter}/lib/utempter/utempter";
        owner = "root";
        group = "utmp";
        setuid = false;
        setgid = true;
      };
    };
  };
}
