{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.malcontent;
}
