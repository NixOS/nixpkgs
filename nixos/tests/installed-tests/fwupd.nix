{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  testConfig = {
    services.fwupd.enable = true;
    services.fwupd.blacklistPlugins = []; # don't blacklist test plugin
    services.fwupd.enableTestRemote = true;
    virtualisation.memorySize = 768;
  };
}
