{ callPackage }:
{ rustc, cargo, ... }: {
  rust = {
    inherit rustc cargo;
  };

  buildRustPackage = callPackage ./default.nix {
    inherit rustc cargo;

    fetchcargo = callPackage ./fetchcargo.nix {
      inherit cargo;
    };
  };

  rustcSrc = callPackage ../../development/compilers/rust/rust-src.nix {
    inherit rustc;
  };
}
