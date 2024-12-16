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
  version = "0-unstable-2024-12-16";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "23932bfa05397e5dfa2844128f0bee7207aabb0a";
    hash = "sha256-BSOh+H3YKuW86wYeZuw18yMLc7yCTr/4NZk/86xKXoQ=";
  };

  cargoHash = "sha256-/B12aXSFGoTtubrT4AqfGrjxZ2RHh7NUf8L0cYr28AQ=";

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
