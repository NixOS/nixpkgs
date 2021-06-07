{ stdenv, rust, rustPlatform, buildPackages }:

{ shortTarget, originalCargoToml, target, RUSTFLAGS }:

let
  cargoSrc = stdenv.mkDerivation {
    name = "cargo-src";
    preferLocalBuild = true;
    phases = [ "installPhase" ];
    installPhase = ''
      RUSTC_SRC=${rustPlatform.rustcSrc.override { minimalContent = false; }} ORIG_CARGO=${originalCargoToml} \
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
  cargoSha256 = "0y6dqfhsgk00y3fv5bnjzk0s7i30nwqc1rp0xlrk83hkh80x81mw";

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
