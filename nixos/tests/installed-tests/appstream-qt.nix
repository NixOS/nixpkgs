{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.libsForQt5.appstream-qt;

  testConfig = {
    appstream.enable = true;
  };
}
