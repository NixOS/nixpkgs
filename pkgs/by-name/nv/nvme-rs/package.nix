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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nvme-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-leD7Y3QdpppaY98QbTw98QDJBAlL3rDnuuqNR8OIXqQ=";
  };

  cargoHash = "sha256-D1pgXq+eCiKE9CamdocmNmXIqkzpFkXGifABzCv7bv8=";

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
