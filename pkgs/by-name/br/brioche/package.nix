{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  callPackage,
  librusty_v8 ? (
    callPackage ./librusty_v8.nix {
      inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
    }
  ),
  openssl,
  tzdata,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brioche";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "brioche-dev";
    repo = "brioche";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tMVBpFCTxesrkj7Z3huVD86baw1tYAtPdPAzYJzTCnA=";
  };

  cargoHash = "sha256-LPHJHS69oUvmTaYoMSINCcyYIHYMq++UCUMh9KrCm/0=";

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # Require internet access
    "--skip=test_bake_process"
  ];

  nativeCheckInputs = [
    # Otherwise, some tests fail with:
    # Error: failed to find time zone `Etc/Unknown` since there is no time zone database configured at line 1 column 415
    tzdata
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    ./update-librusty.sh
  ];

  meta = {
    description = "Package manager for building and running complex software projects";
    homepage = "https://brioche.dev/";
    downloadPage = "https://github.com/brioche-dev/brioche";
    changelog = "https://github.com/brioche-dev/brioche/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "brioche";
  };
})
