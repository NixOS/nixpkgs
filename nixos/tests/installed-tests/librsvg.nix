{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.librsvg;

  testConfig = {
    virtualisation.memorySize = 2047;
  };
}
