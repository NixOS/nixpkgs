{ stdenv, callPackage }:

if stdenv.isDarwin then
  callPackage ./darwin.nix { }
else
  callPackage ./linux.nix { }
