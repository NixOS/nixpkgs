{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  libxcb,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "safecloset";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZLAgSD03Qfoz+uGjVJF7vCkV1pUWqw6yG/9+redbQQ8=";
  };

  cargoHash = "sha256-BSWUWB8OrdmDtU+cGCVp75hakpdd9G3cs9ythDn4nnY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxcb
  ];

  checkFlags = [
    # skip flaky test
    "--skip=timer::timer_tests::test_timer_reset"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform secure TUI secret locker";
    homepage = "https://github.com/Canop/safecloset";
    changelog = "https://github.com/Canop/safecloset/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "safecloset";
  };
})
