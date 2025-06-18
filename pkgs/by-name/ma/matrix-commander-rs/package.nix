{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-commander-rs";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${version}";
    hash = "sha256-ljRFZYfTSyiIVgABgQAVLlwhOmeMumAyZe9tASPtMZA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BMVxxCOAznAsqKUgGHJ9hPgdIksCyzMVUHeLa+om09U=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
}
