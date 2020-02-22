{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  testConfig = {
    services.fwupd.enable = true;
    services.fwupd.blacklistPlugins = lib.mkForce []; # don't blacklist test plugin
    services.fwupd.enableTestRemote = true;
    virtualisation.memorySize = 768;
  };
}
