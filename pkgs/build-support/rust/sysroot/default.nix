{ stdenv, rust, rustPlatform, buildPackages }:

{ shortTarget, originalCargoToml, target, RUSTFLAGS }:

let rustSrc = stdenv.mkDerivation {
    name = "rust-src";
    src = rustPlatform.rust.rustc.src;
    preferLocalBuild = true;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = "cp -r src $out";
  };
  cargoSrc = stdenv.mkDerivation {
      name = "cargo-src";
      preferLocalBuild = true;
      phases = [ "installPhase" ];
      installPhase = ''
        RUSTC_SRC=${rustSrc} ORIG_CARGO=${originalCargoToml} \
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
  cargoSha256 = "1snkfsx3jb1p5izwlfwkgp8hxhgpa35nmx939sp5730vf9whqqwg";

  installPhase = ''
    export LIBS_DIR=$out/lib/rustlib/${shortTarget}/lib
    mkdir -p $LIBS_DIR
    for f in target/${shortTarget}/release/deps/*.{rlib,rmeta}; do
      cp $f $LIBS_DIR
    done

    export RUST_SYSROOT=$(rustc --print=sysroot)
    export HOST=${rust.toRustTarget stdenv.buildPlatform}
    cp -r $RUST_SYSROOT/lib/rustlib/$HOST $out
  '';
}
