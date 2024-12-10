{
  config,
  lib,
  pkgs,
  ...
}:

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

  config =
    let
      goxlr-autostart = pkgs.stdenv.mkDerivation {
        name = "autostart-goxlr-daemon";
        priority = 5;

        buildCommand = ''
          mkdir -p $out/etc/xdg/autostart
          cp ${cfg.package}/share/applications/goxlr-utility.desktop $out/etc/xdg/autostart/goxlr-daemon.desktop
          chmod +w $out/etc/xdg/autostart/goxlr-daemon.desktop
          echo "X-KDE-autostart-phase=2" >> $out/etc/xdg/autostart/goxlr-daemon.desktop
          substituteInPlace $out/etc/xdg/autostart/goxlr-daemon.desktop \
            --replace-fail goxlr-launcher goxlr-daemon
        '';
      };
    in
    mkIf config.services.goxlr-utility.enable {
      services.udev.packages = [ cfg.package ];

      xdg.autostart.enable = mkIf cfg.autoStart.xdg true;
      environment.systemPackages = mkIf cfg.autoStart.xdg [
        cfg.package
        goxlr-autostart
      ];
    };

  meta.maintainers = with maintainers; [ errnoh ];
}
