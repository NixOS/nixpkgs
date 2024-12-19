{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,

  # passthru
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "inv-sig-helper";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "74e879b54e46831e31c09fd08fe672ca58e9cb2d";
    hash = "sha256-Q+u09WWBwWLcLLW9XwkaYDxM3xoQmeJzi37mrdDGvRc=";
  };

  cargoHash = "sha256-qMBztc2N8HWJrrzyzY2KCW9pyv0hK6QJ8tqNdNkhTzE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Rust service that decrypts YouTube signatures and manages player information";
    homepage = "https://github.com/iv-org/inv_sig_helper";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "inv_sig_helper_rust";
  };
}
