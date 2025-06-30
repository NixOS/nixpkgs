{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  testConfig = {
    services.fwupd = {
      enable = true;
      daemonSettings.TestDevices = true;
    };
  };
}
