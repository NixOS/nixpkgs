{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  dbus,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-reticulum";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsReticulum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MSvIgB/E1Ce8M8vOaXlHQGYnxFf0lT2hg8g0tx6QY/w=";
  };

  cargoHash = "sha256-Kv3aVET69yI28muyaJop4YQEqOxNeyajK7j5J+jDhe0=";

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

  checkFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Broken since 0.9.4
    "--skip=actor::tests::test_rate_tracking"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rnid-rs";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratspeak/rsReticulum/releases/tag/${finalAttrs.src.tag}";
    description = "Rust implementation of the Reticulum networking stack";
    homepage = "https://github.com/ratspeak/rsReticulum";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
