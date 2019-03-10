{ callPackage }:

(callPackage ./Cargo.nix {cratesIO = callPackage ./crates-io.nix {};}).cargo_vendor {}
