{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.niri;
in
{
  options.programs.niri = {
    enable = lib.mkEnableOption "Niri, a scrollable-tiling Wayland compositor";

    package = lib.mkPackageOption pkgs "niri" { };

    # Recommended by upstream
    # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-gnome" {
      # https://github.com/NixOS/nixpkgs/pull/348193#discussion_r1798515394
      extraDescription = "Note: `xdg-desktop-portal-gnome` is required for screencast support";
    };

    xwayland.enable = lib.mkEnableOption "XWayland support via xwayland-satellite";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          cfg.package
        ] ++ lib.optional cfg.xwayland.enable pkgs.xwayland-satellite;

        services = {
          displayManager.sessionPackages = [ cfg.package ];

          # Recommended by upstream
          # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        systemd = {
          packages = [ cfg.package ];

          # Recommended by upstream
          # https://github.com/YaLTeR/niri/wiki/Important-Software#authentication-agent
          user.services.niri-polkit-agent = lib.mkIf config.security.polkit.enable {
            description = "Niri PolicyKit Authentication Agent";
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "niri.service" ];
            serviceConfig = {
              BusName = "org.kde.polkit-kde-authentication-agent-1";
              ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
              Restart = "on-failure";
              Slice = "background.slice";
              TimeoutSec = "5sec";
            };
          };
        };

        xdg.portal = {
          enable = lib.mkDefault true;

          configPackages = [ cfg.package ];
          extraPortals = [ cfg.portalPackage ];
        };
      }

      (import ./wayland-session.nix {
        inherit lib pkgs;
        enableWlrPortal = false;
        enableXWayland = false;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    getchoo
    sodiboo
  ];
}
