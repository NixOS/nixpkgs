{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvme-rs";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nvme-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I6OB1l0YC+4l7udIPSryXPlPD9vS9FO5pV3MMZ+pWXc=";
  };

  cargoHash = "sha256-Ra3NmfDkQQs+Z7itjBNBNlybZl0/ldNAp6Xq8Ct47bc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
