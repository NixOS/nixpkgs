{
  pkgs,
  lib,
  makeInstalledTest,
  ...
}:

makeInstalledTest {
  tested = pkgs.ostree;

  testConfig = {
    environment.systemPackages = with pkgs; [
      gnupg
      ostree
    ];
  };
}
