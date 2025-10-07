{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.winbox;
in
{
  options.programs.winbox = {
    enable = lib.mkEnableOption "MikroTik Winbox";
    package = lib.mkPackageOption pkgs "winbox" { };

    openFirewall = lib.mkOption {
      description = ''
        Whether to open ports for the MikroTik Neighbor Discovery protocol. Required for Winbox neighbor discovery.
      '';
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [ 5678 ];
      allowedUDPPortRanges = [
        {
          from = 40000;
          to = 50000;
        }
      ];
    };
  };
}
