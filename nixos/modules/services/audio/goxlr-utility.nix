{ config, lib, pkgs, ... }:

let
  cfg = config.services.goxlr-utility;
in

with lib;
{

  options = {
    services.goxlr-utility = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable goxlr-utility for controlling your TC-Helicon GoXLR or GoXLR Mini
        '';
      };
      package = mkPackageOption pkgs "goxlr-utility" { };
      autoStart.xdg = mkOption {
        default = true;
        type = with types; bool;
        description = ''
          Start the daemon automatically using XDG autostart.
          Sets `xdg.autostart.enable = true` if not already enabled.
        '';
      };
    };
  };

  config = mkIf config.services.goxlr-utility.enable
    {
      services.udev.packages = [ cfg.package ];

      xdg.autostart.enable = mkIf cfg.autoStart.xdg true;
      environment.systemPackages = mkIf cfg.autoStart.xdg
        [
          cfg.package
          (pkgs.makeAutostartItem
            {
              name = "goxlr-utility";
              package = cfg.package;
            })
        ];
    };

  meta.maintainers = with maintainers; [ errnoh ];
}
