{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcrwallet";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${finalAttrs.version}";
    hash = "sha256-oB+E2NVz4zlLUWBhdmyGq2jfsMLuF2OpPkBn7/daxDw=";
  };

  vendorHash = "sha256-P9u+Pxy/TtArhU/fu2nXg6PyyoCm9GPLVRX6twheERQ=";

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
})
