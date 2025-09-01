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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nvme-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lkuOPe5gYhboK9zylTCVN1DFWCFRHhfJa7tNEHH/GQM=";
  };

  cargoHash = "sha256-MNEG6GGfMg1FXodD8yEMqvm8lYkQgYXMc/vR4lV166I=";

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
