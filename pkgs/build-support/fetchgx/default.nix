{ stdenv, gx, gx-go, go, cacert }:

{ name, src, sha256 }:

stdenv.mkDerivation {
  name = "${name}-gxdeps";
  inherit src;

  buildInputs = [ cacert go gx gx-go ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    export GOPATH=$(pwd)/vendor
    mkdir -p vendor
    gx install
  '';

  installPhase = ''
    mv vendor $out
  '';

  preferLocalBuild = true;
}
