{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gjs;
  withX11 = true;
}
