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
    # https://github.com/YaLTeR/niri/wiki/Important-Software#authentication-agent
    polkitAgent.enable = lib.mkEnableOption "a PolicyKit agent service" // {
      default = config.security.polkit.enable;
      defaultText = "config.security.polkit.enable";
    };

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
        environment.systemPackages = [ cfg.package ];

        services = {
          displayManager.sessionPackages = [ cfg.package ];

          # Recommended by upstream
          # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        systemd.packages = [ cfg.package ];

        xdg.portal = {
          enable = lib.mkDefault true;

          configPackages = [ cfg.package ];
          extraPortals = [ cfg.portalPackage ];
        };
      }

      (lib.mkIf cfg.polkitAgent.enable {
        systemd.user.services.niri-polkit-agent = {
          description = "Niri PolicyKit Authentication Agent";
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "niri.service" ];

          script = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";

          serviceConfig = {
            BusName = "org.kde.polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            Slice = "background.slice";
            TimeoutSec = "5sec";
          };
        };
      })

      (lib.mkIf cfg.xwayland.enable {
        environment.systemPackages = [ pkgs.xwayland-satellite ];
      })

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
