{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcrwallet";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${finalAttrs.version}";
    hash = "sha256-VDj2H+5jsNza09eXcJTtgdgni4JUK64Y/e8xNSbd3Ro=";
  };

  vendorHash = "sha256-5bn55tQpkNTShxMddaojlBYQ2s9uLbgLmrHl7gpMdB0=";

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
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ juaningan ];
    mainProgram = "dcrwallet";
  };
})
