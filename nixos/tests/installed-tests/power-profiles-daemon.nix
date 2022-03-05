{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.power-profiles-daemon;

  testConfig = {
    services.power-profiles-daemon.enable = true;
  };
}
