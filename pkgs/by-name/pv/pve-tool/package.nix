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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "pve-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4KivXnDzjKSzqgAYvqe+IP/7htxOtI2HWjMkj71uCtA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PAyb2XjHkTeStFrUkHVuaa6hvfr3llHCXcewSJTvPgc=";

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
