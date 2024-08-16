{ lib, stdenv, rustPlatform, buildPackages
, originalCargoToml ? null
}:

stdenv.mkDerivation {
  name = "cargo-src";
  preferLocalBuild = true;

  unpackPhase = "true";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    export RUSTC_SRC=${rustPlatform.rustLibSrc.override { }}
  ''
  + lib.optionalString (originalCargoToml != null) ''
    export ORIG_CARGO=${originalCargoToml}
  ''
  + ''
    ${buildPackages.python3.withPackages (ps: with ps; [ toml ])}/bin/python3 ${./cargo.py}
    mkdir -p $out/src
    echo '#![no_std]' > $out/src/lib.rs
    cp Cargo.toml $out/Cargo.toml
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
}
