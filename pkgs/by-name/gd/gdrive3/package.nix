{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "gdrive";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "glotlabs";
    repo = "gdrive";
    rev = version;
    hash = "sha256-vWd1sto89U2ZJWZZebPjrbMyBjZMs9buoPEPKocDVnY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "google-apis-common-5.0.2" = "sha256-E4ON66waUzp4qqpVWTFBD0+M2V80YlYmsewEYZygTuE=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Google Drive CLI Client";
    homepage = "https://github.com/glotlabs/gdrive";
    changelog = "https://github.com/glotlabs/gdrive/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gdrive";
  };
}
