{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtui";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Troels51";
    repo = "dtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bAg9FFoKXb6YClNQRhR7Z/MhnPkJ8r7/xM6SghaH2hU=";
  };

  cargoHash = "sha256-qiFxN0bG3pUWOKKM0gHMmxjZZvqZXYYDeUuRI/V9YbM=";

  nativeBuildInputs = [
    pkg-config
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "dBus TUI for introspecting your current dbus session/system";
    mainProgram = "dtui";
    homepage = "https://github.com/Troels51/dtui";
    changelog = "https://github.com/Troels51/dtui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
