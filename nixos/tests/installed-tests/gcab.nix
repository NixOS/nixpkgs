{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gcab;
}
