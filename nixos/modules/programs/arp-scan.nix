{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.arp-scan;
in
{
  options = {
    programs.arp-scan = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure a setcap wrapper for arp-scan.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.arp-scan = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = lib.getExe pkgs.arp-scan;
    };
  };
}
