{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${version}";
    hash = "sha256-fsmil9YQNvXDyBxyt+Ei3F5U/dvbrzbZ01+v9o3+jVY=";
  };

  vendorHash = "sha256-ehtgsBCFzMft8285IjpsQ6y9HPb/UpZmcj9X4m8ZKXo=";

  subPackages = [ "." ];

  checkFlags = [
    # Test fails with:
    # 'x509_test.go:201: server did not report bad certificate error;
    # instead errored with [...] tls: unknown certificate authority (*url.Error)'
    "-skip=^TestUntrustedClientCert$"
  ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
    mainProgram = "dcrwallet";
  };
}
