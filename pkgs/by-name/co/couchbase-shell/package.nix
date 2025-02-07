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

  useFetchCargoVendor = true;
  cargoHash = "sha256-8AnnZNXp/D8lUCohgrLzqJ+7gwucC3OBh1TK3dYKp4Y=";

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
