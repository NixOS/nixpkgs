{
  callPackage,
  stdenv,
}:

callPackage (if stdenv.hostPlatform.isDarwin then ./package-darwin.nix else ./package-linux.nix) { }
