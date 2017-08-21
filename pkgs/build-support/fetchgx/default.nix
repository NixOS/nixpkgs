{ stdenv, gx, gx-go, go, cacert }:

{ name, src, sha256 }:

stdenv.mkDerivation {
  name = "${name}-gxdeps";
  inherit src;

  buildInputs = [ go gx gx-go ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

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
