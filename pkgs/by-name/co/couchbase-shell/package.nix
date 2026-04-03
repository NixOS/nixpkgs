{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  testers,
  nix-update-script,
  couchbase-shell,
}:

rustPlatform.buildRustPackage rec {
  pname = "couchbase-shell";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "couchbaselabs";
    repo = "couchbase-shell";
    rev = "v${version}";
    hash = "sha256-sxKf0AdUpV3SgGkXYQSJn5q+l2NrxvWxrFQvzAt1PVo=";
  };

  cargoHash = "sha256-o9bfbmtPROU9XD1R6pLrH4UK5OE92RWu2fpekWcrexY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # tests need couchbase server
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = couchbase-shell;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Shell for Couchbase Server and Cloud";
    homepage = "https://couchbase.sh/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ petrkozorezov ];
    mainProgram = "cbsh";
    platforms = lib.platforms.linux;
  };
}
