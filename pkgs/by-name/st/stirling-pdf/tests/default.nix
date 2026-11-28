{ pkgs }:
{
  basic = pkgs.testers.runNixOSTest ./basic.nix;
  stirling-pdf-modular = pkgs.testers.runNixOSTest ./modular.nix;
  stirling-pdf-desktop = pkgs.testers.runNixOSTest ./desktop-integration-test.nix;
}
