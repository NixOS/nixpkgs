{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  # same as fwupd upstream CI
  testRunnerFlags = [ "--timeout=1200" ];

  testConfig = {
    # for easier debugging
    systemd.globalEnvironment.FWUPD_VERBOSE = "1";

    services.fwupd = {
      enable = true;
      daemonSettings.TestDevices = true;
    };
  };
}
