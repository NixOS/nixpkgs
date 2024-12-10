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
  version = "0-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "ac0269f1586df5a853c4321256866bcbea89802b";
    hash = "sha256-w8ZvNCs6xz79RjAzIVhtYRJoLzC97RYm2U1ydao3Ons=";
  };

  cargoHash = "sha256-Y9q64ltv2QRtRUy5t40JIfwFh8ryO1D0Gdg7xO1azws=";

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
