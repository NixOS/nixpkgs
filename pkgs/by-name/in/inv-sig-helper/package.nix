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
  version = "0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "35bc77247b8718ff2705a5f4cbbb3845d02eb65f";
    hash = "sha256-WMIKJb85yauEmyfgSl0zNFBfeXya8Ms2MWGNKo6+T1s=";
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
