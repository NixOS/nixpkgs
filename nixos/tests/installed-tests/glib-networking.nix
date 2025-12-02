{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.glib-networking;
}
