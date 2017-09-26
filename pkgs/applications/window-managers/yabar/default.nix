{ callPackage, attrs ? {} }:

let
  overrides = {
    version = "0.4.0";

    rev = "746387f0112f9b7aa2e2e27b3d69cb2892d8c63b";
    sha256 = "1nw9dar1caqln5fr0dqk7dg6naazbpfwwzxwlkxz42shsc3w30a6";
  } // attrs;
in callPackage ./build.nix overrides
