{ lib, stdenv, rustPlatform, buildPackages
, originalCargoToml ? null
}:

stdenv.mkDerivation {
  name = "cargo-src";
  preferLocalBuild = true;
  phases = [ "installPhase" ];
  installPhase = ''
    export RUSTC_SRC=${rustPlatform.rustcSrc.override { minimalContent = false; }}
  ''
  + lib.optionalString (originalCargoToml != null) ''
    export ORIG_CARGO=${originalCargoToml}
  ''
  + ''
    ${buildPackages.python3.withPackages (ps: with ps; [ toml ])}/bin/python3 ${./cargo.py}
    mkdir -p $out
    cp Cargo.toml $out/Cargo.toml
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
}
