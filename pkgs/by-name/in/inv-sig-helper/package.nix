{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,

  # passthru
  nixosTests,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "inv-sig-helper";
  version = "0-unstable-2025-02-07";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "ac006283c0b6821c856d6293c2ce49b61fa8c46a";
    hash = "sha256-cQXWo+idyfFeJ2nnT8HKgjCd0Htc4pOE6aODsl3sf/8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DnJL7kkcVn5dW3AoPCn829WmkaCjpDZtYUXnpiB857Q=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru = {
    tests = {
      inherit (nixosTests) invidious;
    };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Rust service that decrypts YouTube signatures and manages player information";
    homepage = "https://github.com/iv-org/inv_sig_helper";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "inv_sig_helper_rust";
  };
}
