{ stdenv, name, src, patches ? [], buildInputs ? [] }:
stdenv.mkDerivation {
  inherit src buildInputs patches name;
  installPhase = "cp -r . $out";
  phases = ["unpackPhase" "patchPhase" "installPhase"];
}
