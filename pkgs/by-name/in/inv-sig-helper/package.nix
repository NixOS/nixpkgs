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
  version = "0-unstable-2025-04-03";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "9073c15822c33ffefa27b55ef2d05fbddfc03273";
    hash = "sha256-HVaux1QzN625f9rS2J1i3es/ZMjvVqKTY6MvBdcgg/o=";
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
