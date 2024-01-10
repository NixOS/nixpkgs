{ lib, stdenv, rustPlatform, buildPackages }:

{ shortTarget, originalCargoToml, target, RUSTFLAGS }:

let
  cargoSrc = import ../../sysroot/src.nix {
    inherit lib stdenv rustPlatform buildPackages originalCargoToml;
  };
in rustPlatform.buildRustPackage {
  inherit target RUSTFLAGS;

  name = "custom-sysroot";
  src =  cargoSrc;

  RUSTC_BOOTSTRAP = 1;
  __internal_dontAddSysroot = true;
  cargoSha256 = "sha256-zgkwevitxsu1C4OgGTsqNSc0gDxaNXYK1WPbfER48d0=";

  doCheck = false;

  installPhase = ''
    export LIBS_DIR=$out/lib/rustlib/${shortTarget}/lib
    mkdir -p $LIBS_DIR
    for f in target/${shortTarget}/release/deps/*.{rlib,rmeta}; do
      cp $f $LIBS_DIR
    done

    export RUST_SYSROOT=$(rustc --print=sysroot)
    host=${stdenv.buildPlatform.rust.rustcTarget}
    cp -r $RUST_SYSROOT/lib/rustlib/$host $out
  '';

  # allows support for cross-compilation
  meta.platforms = lib.platforms.all;
}
