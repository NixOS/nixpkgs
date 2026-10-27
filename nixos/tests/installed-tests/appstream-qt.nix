{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.kdePackages.appstream-qt;

  testConfig = {
    appstream.enable = true;
  };
}
