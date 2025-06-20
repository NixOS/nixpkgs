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
  pname = "pve-tool";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "pve-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s1W4PCNJMk0YQ0eDh0SoPDAhRwBPOLhf7o4kNIrAho8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9W5AqwmIpsXK3Jx9VPQAPBmbDuroCmUKF4lBEeWqpFQ=";

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
    description = "Lightweight tool for managing Proxmox VE snapshots across multiple nodes in a cluster";
    homepage = "https://github.com/liberodark/pve-tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "pve-tool";
  };
})
