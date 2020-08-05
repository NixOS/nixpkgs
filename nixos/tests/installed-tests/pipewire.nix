{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.pipewire;
}
