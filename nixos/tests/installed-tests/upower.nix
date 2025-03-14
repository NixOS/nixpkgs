{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.upower;

  testConfig = {
    services.upower.enable = true;
  };
}
