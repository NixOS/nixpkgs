{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.glib-testing;
}
