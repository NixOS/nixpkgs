{ config, lib, pkgs, ... }:

let

  cfg  = config.programs.mosh;

in
{
  options.programs.mosh = {
    enable = lib.mkEnableOption "mosh";
    openFirewall = lib.mkEnableOption "" // {
      description = "Whether to automatically open the necessary ports in the firewall.";
      default = true;
    };
    withUtempter = lib.mkEnableOption "" // {
      description = lib.mdDoc ''
        Whether to enable libutempter for mosh.

        This is required so that mosh can write to /var/run/utmp (which can be queried with `who` to display currently connected user sessions).
        Note, this will add a guid wrapper for the group utmp!
      '';
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mosh ];
    networking.firewall.allowedUDPPortRanges = lib.optional cfg.openFirewall { from = 60000; to = 61000; };
    security.wrappers = lib.mkIf cfg.withUtempter {
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
