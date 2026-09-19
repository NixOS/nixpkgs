{ lib, ... }:
{
  name = "gtk-icon-cache";
  meta.maintainers = [ ];

  nodes = {
    # A Wayland session sets services.graphical-desktop.enable without
    # services.xserver.enable, the way programs/wayland/wayland-session.nix does
    # for sway, hyprland, niri and friends.
    wayland =
      { ... }:
      {
        services.graphical-desktop.enable = true;
      };

    headless =
      { ... }:
      {
        services.graphical-desktop.enable = false;
      };
  };

  testScript = ''
    start_all()

    wayland.wait_for_unit("multi-user.target")
    headless.wait_for_unit("multi-user.target")

    cache = "/run/current-system/sw/share/icons/hicolor/icon-theme.cache"

    # A graphical session gets icon theme caches even without X11.
    wayland.succeed(f"test -f {cache}")

    # A headless system does not build them.
    headless.fail(f"test -e {cache}")
  '';
}
