{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dcrwallet";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${version}";
    hash = "sha256-pb8ndOzo/PKqwpMYjsbibM391ceV9uN37ib0sUAgDkY=";
  };

  vendorHash = "sha256-UJS+ALTAyMEGBhOKk/pknxE143uPpvoDlBaS7H3TqBA=";

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
