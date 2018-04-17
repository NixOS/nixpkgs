{ stdenv, lib, go, buildGoPackage, dep, fetchgit, git, cacert }:

buildGoPackage rec {
  name = "dcrd-${version}";
  version = "1.1.2";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/decred/dcrd";

  buildInputs = [ go git dep cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "0xcynipdn9zmmralxj0hjrwyanvhkwfj2b1vvjk5zfc95s2xc1q9";
  };

  preBuild = ''
    export CWD=$(pwd)
    cd go/src/github.com/decred/dcrd
    dep ensure
    go install . ./cmd/...
    cd $CWD
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
  };
}
