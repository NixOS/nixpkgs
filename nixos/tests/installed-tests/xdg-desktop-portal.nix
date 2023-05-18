{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.xdg-desktop-portal;

  # Ton of breakage.
  # https://github.com/flatpak/xdg-desktop-portal/pull/428
  meta.broken = true;
}
