{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.xdg-desktop-portal;
}
