{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  dbus,
  python3,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-reticulum";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsReticulum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CoA+HOcMkwmo7WUhXCLIwx4hMqLHFQqu6d1NOz1N2PY=";
  };

  cargoHash = "sha256-h8P2PuW3hiyQuvAHhat831dxBGSmV0rxDWB8lffZpac=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    dbus
  ];

  nativeCheckInputs = [
    python3
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratspeak/rsReticulum/releases/tag/${finalAttrs.src.tag}";
    description = "Rust implementation of the Reticulum networking stack";
    homepage = "https://github.com/ratspeak/rsReticulum";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rs-reticulum";
  };
})
