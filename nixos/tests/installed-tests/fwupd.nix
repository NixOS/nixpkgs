{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.fwupd;

  testConfig = {
    services.fwupd.enable = true;
    services.fwupd.disabledPlugins = lib.mkForce []; # don't disable test plugin
    services.fwupd.enableTestRemote = true;
  };
}
