{ stdenv, callPackage }:
if stdenv.hostPlatform.system == "aarch64-linux" then
  callPackage ./signal-desktop-aarch64.nix { }
else if stdenv.hostPlatform.isDarwin then
  callPackage ./signal-desktop-darwin.nix { }
else
  callPackage ./signal-desktop.nix { }
