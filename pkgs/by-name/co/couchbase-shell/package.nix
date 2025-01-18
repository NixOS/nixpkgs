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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "couchbaselabs";
    repo = "couchbase-shell";
    rev = "v${version}";
    hash = "sha256-ksAyi7yMz56de1lA2LYVNdsn02GNrcJVoRLcK1zFppE=";
  };

  cargoHash = "sha256-efy1M4Q9dBfEq0YYUKn4y1Rz/dPbBYLapcPXJLI9X+Q=";

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

  meta = with lib; {
    description = "Shell for Couchbase Server and Cloud";
    homepage = "https://couchbase.sh/";
    license = licenses.asl20;
    maintainers = with maintainers; [ petrkozorezov ];
    mainProgram = "cbsh";
    platforms = platforms.linux;
  };
}
