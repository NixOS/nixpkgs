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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "safecloset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Mvn2gWYcIotnAOBZnTSFawF9qORCh3Pfce6SVGjO24=";
  };

  cargoHash = "sha256-l7/bgYpiCBBk1uKL2AQb+3UNXJLHA9AQJVMPs64Ka+Y=";

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
