{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.libxmlb;
}
