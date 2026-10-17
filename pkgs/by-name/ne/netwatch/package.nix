{
  fetchFromGitHub,
  lib,
  libpcap,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netwatch-tui";
  version = "0.35.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fq0Nj7qd0J3ML/++3tm4O7XHkT/KMzhm/ca7ak3QYFo=";
  };

  cargoHash = "sha256-PsR8Bv77Esrhn9Ax0PPtxuDngEOPlhYGhevGhyFzps0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  checkFlags = [
    # Spawns child processes and attributes their live TCP connections back
    # by PID, then asserts every flow was attributed correctly. In the build
    # sandbox the children's sockets are not attributable, so the counts land
    # in the "unknown" bucket instead: (0, 0, 2) where (2, 0, 0) is expected.
    # New at 0.35.3 (0.30.0 built clean); the other 1452 tests pass.
    "--skip=collectors::connections::tests::controlled_polling_matrix_matches_independent_processes"
  ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time network diagnostics in your terminal.";
    homepage = "https://www.netwatchlabs.com/labs/netwatch";
    changelog = "https://github.com/matthart1983/netwatch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "netwatch";
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
