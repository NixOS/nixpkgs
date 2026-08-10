{ callPackage, pkgs }:
let
  stdenv = pkgs.rustc.llvmPackages.stdenv;
  mkBraveSource = flavor: callPackage ./browser.nix { inherit flavor stdenv; };
in
{
  brave = mkBraveSource "browser";
  brave-origin = mkBraveSource "origin";
}
