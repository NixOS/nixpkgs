{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvme-rs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nvme-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhvjwrrX4Av6eZlg5yMamtVkqSKIY8hwuOwzRwXT94M=";
  };

  cargoHash = "sha256-I7cpLnE9d/GwKBkAok4qNNQiBwHXrsAbtiHDKMw+QYY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight tool for monitoring NVMe drive health with email alerts";
    homepage = "https://github.com/liberodark/nvme-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "nvme-rs";
  };
})
