{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.json-glib;
}
