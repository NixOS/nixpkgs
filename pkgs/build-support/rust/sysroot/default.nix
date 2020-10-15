{ stdenv, rust, rustPlatform, buildPackages }:

{ shortTarget, originalCargoToml, target, RUSTFLAGS }:

let
  cargoSrc = stdenv.mkDerivation {
    name = "cargo-src";
    preferLocalBuild = true;
    phases = [ "installPhase" ];
    installPhase = ''
      RUSTC_SRC=${rustPlatform.rustcSrc} ORIG_CARGO=${originalCargoToml} \
        ${buildPackages.python3.withPackages (ps: with ps; [ toml ])}/bin/python3 ${./cargo.py}
      mkdir -p $out
      cp Cargo.toml $out/Cargo.toml
      cp ${./Cargo.lock} $out/Cargo.lock
    '';
  };
in rustPlatform.buildRustPackage {
  inherit target RUSTFLAGS;

  name = "custom-sysroot";
  src =  cargoSrc;

  RUSTC_BOOTSTRAP = 1;
  __internal_dontAddSysroot = true;
  cargoSha256 = "1l5z44dw5h7lbwmpjqax2g40cf4h27yai3wlj0p5di5v1xf25rng";

  doCheck = false;

  installPhase = ''
    export LIBS_DIR=$out/lib/rustlib/${shortTarget}/lib
    mkdir -p $LIBS_DIR
    for f in target/${shortTarget}/release/deps/*.{rlib,rmeta}; do
      cp $f $LIBS_DIR
    done

    export RUST_SYSROOT=$(rustc --print=sysroot)
    host=${rust.toRustTarget stdenv.buildPlatform}
    cp -r $RUST_SYSROOT/lib/rustlib/$host $out
  '';
}
