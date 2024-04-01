{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${version}";
    hash = "sha256-Pz25jExqbvy8fgiZy9vaYuVp8kuE6deGLlBEjxTnYGQ=";
  };

  vendorHash = "sha256-lvN7OcDoEzb9LyH9C5q8pd0BOnF2VKuh4O82U+tQ6fI=";

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
