{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.appstream;

  testConfig = {
    appstream.enable = true;
  };
}
