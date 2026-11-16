{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtui";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "Troels51";
    repo = "dtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vt9PVJtzRFBBlZ0tggs4Q0pBiojr5V1wABS7sfAAw90=";
  };

  cargoHash = "sha256-QKnupGJWYq7Q77sP7HVMBmQihaSouNJFGOkDXhH5rL4=";

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
