{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.colord;
}
