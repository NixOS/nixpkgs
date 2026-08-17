{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gnomeExtensions.gsconnect;

  withX11 = true;
}
