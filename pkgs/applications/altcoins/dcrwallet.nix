{ stdenv, lib, go, buildGoPackage, dep, fetchgit, git, cacert }:

buildGoPackage rec {
  name = "dcrwallet-${version}";
  version = "1.1.2";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/decred/dcrwallet";

  buildInputs = [ go git dep cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "058im4vmcmxcl5ir14h17wik5lagp2ay0p8qc3r99qmpfwvvz39x";
  };

  preBuild = ''
    export CWD=$(pwd)
    cd go/src/github.com/decred/dcrwallet
    dep ensure
  '';

  buildPhase = ''
    runHook preBuild
    go build
  '';

  installPhase = ''
    mkdir -pv $bin/bin
    cp -v dcrwallet $bin/bin
  '';


  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
  };
}
