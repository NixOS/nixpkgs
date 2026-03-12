{ pkgs }:
{
  basic = pkgs.testers.runNixOSTest ./basic.nix;
  stirling-pdf-modular = pkgs.testers.runNixOSTest ./modular.nix;
}
