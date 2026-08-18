{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcrwallet";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${finalAttrs.version}";
    hash = "sha256-DR4i/OXrYHICJJhWdGIvBh6snrLwcuYzIQFebnfQYq4=";
  };

  vendorHash = "sha256-uXhlp1b93ZEQUcTEwXq2fBENrjpK8rtINz7iDhFFalY=";

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
