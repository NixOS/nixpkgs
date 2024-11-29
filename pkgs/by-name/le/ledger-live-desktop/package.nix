{ stdenv, callPackage }:

let
  self = rec {
    ledger-live-desktop = if stdenv.hostPlatform.isDarwin then
      callPackage ./ledger-live-desktop-darwin.nix { }
    else
      callPackage ./ledger-live-desktop-linux.nix { };
  };
in self
