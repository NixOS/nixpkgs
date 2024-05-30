{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "aw-awatcher";
  version = "v0.2.7";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = "awatcher";
    rev = version;
    hash = "sha256-e65QDbK55q1Pbv/i7bDYRY78jgEUD1q6TLdKD8Gkswk=";
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    outputHashes = {
      "aw-client-rust-0.1.0" = "sha256-fCjVfmjrwMSa8MFgnC8n5jPzdaqSmNNdMRaYHNbs8Bo=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Activity and idle watchers";
    homepage = "https://github.com/2e3s/awatcher";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bhasher ];
    mainProgram = "awatcher";
    platforms = lib.platforms.linux;
  };
}
