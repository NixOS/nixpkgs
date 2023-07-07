{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.sharing = {
    enable = mkEnableOption (lib.mdDoc ''
      sharing, a CLI tool for sharing files.

      Note that it will opens the 7478 port for TCP in the firewall, which is needed for it to function properly
    '');
  };
  config =
    let
      cfg = config.programs.sharing;
    in
      mkIf cfg.enable {
        environment.systemPackages = [ pkgs.sharing ];
        networking.firewall.allowedTCPPorts = [ 7478 ];
      };
}
