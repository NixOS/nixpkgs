{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "awatcher";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-e65QDbK55q1Pbv/i7bDYRY78jgEUD1q6TLdKD8Gkswk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # NOTE needed due to Cargo.lock containing git dependencies
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "aw-client-rust-0.1.0" = "sha256-fCjVfmjrwMSa8MFgnC8n5jPzdaqSmNNdMRaYHNbs8Bo=";
    };
  };

  meta = with lib; {
    description = "A window activity and idle watcher for ActivityWatcher with an optional tray and UI for statistics";
    homepage = "https://github.com/2e3s/awatcher";
    changelog = "https://github.com/2e3s/awatcher/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ tsandrini ];
    platforms = platforms.linux;
    mainProgram = "awatcher";
  };
}
