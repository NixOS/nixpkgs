{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.somewm;
in
{
  options.programs.somewm = {
    enable = lib.mkEnableOption "somewm, an AwesomeWM-compatible Wayland compositor";

    package = lib.mkPackageOption pkgs "somewm" {
      example = "pkgs.somewm.override { extraLuaPackages = ps: [ ps.luafilesystem ]; }";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        services = {
          displayManager.sessionPackages = [ cfg.package ];
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        xdg.portal = {
          enable = lib.mkDefault true;

          config.somewm = {
            default = [
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];
            "org.freedesktop.impl.portal.Inhibit" = [ "gtk" ];
          };
        };
      }

      (import ./wayland-session.nix { inherit lib pkgs; })
    ]
  );

  meta.maintainers = with lib.maintainers; [ yvnth ];
}
