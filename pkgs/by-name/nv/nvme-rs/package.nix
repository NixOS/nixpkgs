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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nvme-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yM0jzqO+BpsIcr+IMZf5idAY4DTpLxP1VGISzhWhOlI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-V9drHGeY0dvMVdCd016kELGZe7r/Qhia8fGRI9CO/ns=";

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
