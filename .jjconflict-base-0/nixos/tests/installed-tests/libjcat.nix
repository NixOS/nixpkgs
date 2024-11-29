{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.libjcat;
}
