{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${version}";
    hash = "sha256-sRwGpOVydfZjgo7W+4RsHC4JElPyilbV5xhcHxPh2Wc=";
  };

  vendorHash = "sha256-lVVIS3FL8XwthCpzRKdw59NVtHVxXQ0ouD7jYQzOecM=";

  subPackages = [ "." ];

  checkFlags = [
    # Test fails with:
    # 'x509_test.go:201: server did not report bad certificate error;
    # instead errored with [...] tls: unknown certificate authority (*url.Error)'
    "-skip=^TestUntrustedClientCert$"
  ];

  meta = {
    homepage = "https://decred.org";
    description = "Secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
    mainProgram = "dcrwallet";
  };
}
