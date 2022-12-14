{ lib, stdenv, rust, rustPlatform, buildPackages }:

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
  cargoLock.lockFile = ../../sysroot/Cargo.lock;

  doCheck = false;

  buildPhase = ''
    cargo build --frozen --release --target ${target}
  '';

  installPhase = ''
    export LIBS_DIR=$out/lib/rustlib/${shortTarget}/lib
    mkdir -p $LIBS_DIR
    for f in target/${shortTarget}/release/deps/*.{rlib,rmeta}; do
      cp $f $LIBS_DIR
    done

    export RUST_SYSROOT=$(rustc --print=sysroot)
    host=${rust.toRustTarget stdenv.buildPlatform}
    ln -s $RUST_SYSROOT/lib/rustlib/$host $out/lib/rustlib/
  '';
}
