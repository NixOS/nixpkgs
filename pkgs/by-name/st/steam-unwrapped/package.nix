{
  callPackage,
  stdenv,
  ...
}:

callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) { }
