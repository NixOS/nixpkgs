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
  version = "0.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "pve-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZzHTtQv47ZWluMDbq4JNMze44lwSYGhsILUNS9TygDw=";
  };

  cargoHash = "sha256-ZEemiy10NqZM700PgHxpNmkAUD29XLOYBy7xdYHpCt0=";

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
    description = "Lightweight tool for managing Proxmox VE snapshots across multiple nodes in a cluster";
    homepage = "https://github.com/liberodark/pve-tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "pve-tool";
  };
})
