{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.pipewire;
}
