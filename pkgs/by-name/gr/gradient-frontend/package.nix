# pkgs/by-name/gr/gradient-frontend/package.nix
{
  callPackage,
  gradient,
}:

callPackage ./frontend.nix {
  inherit gradient;
}
