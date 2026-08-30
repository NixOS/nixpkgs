{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gjs;
  withX11 = true;

  testConfig = {
    environment.systemPackages = [
      pkgs.gjs
    ];
  };
}
