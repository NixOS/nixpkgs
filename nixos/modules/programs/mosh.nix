{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.programs.mosh;

in
{
  options.programs.mosh = {
    enable = mkOption {
      description = ''
        Whether to enable mosh. Note, this will open ports in your firewall!
      '';
      default = false;
      type = lib.types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mosh ];
    networking.firewall.allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
  };
}
