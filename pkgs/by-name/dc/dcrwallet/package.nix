{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcrwallet";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${finalAttrs.version}";
    hash = "sha256-9CblBsZa2jAzp58Qj/Zoq68JcuKxzDO51P19XZJIJ6I=";
  };

  vendorHash = "sha256-J1Iy3XWvLNLEf+0kDYbX1UbgBvxz7C3NSPeF/PpuD5E=";

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
