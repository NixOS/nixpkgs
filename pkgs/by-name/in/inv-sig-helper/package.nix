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
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "40835906774cc7cdefa76b2648216afd063ad0e2";
    hash = "sha256-yjVN81VSXPOXSOhhlF6Jjc/7sYsdoWT+Tr1BA+C2XQI=";
  };

  cargoHash = "sha256-JUX4s4ZYmvGliBMXnMntrmeuoRkmTmzLzvXWQtJIh6M=";

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
