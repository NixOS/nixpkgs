{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  # same as fwupd upstream CI
  testRunnerFlags = [ "--timeout=1200" ];

  testConfig = {
    services.fwupd = {
      enable = true;
      daemonSettings.TestDevices = true;
    };
  };
}
