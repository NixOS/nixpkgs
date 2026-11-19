{
  clangStdenv,
  fetchFromGitHub,
  gitMinimal,
  lib,
  oniguruma,
  pkg-config,
  rustPlatform,
  useMoldLinker,
  withMold ? clangStdenv.hostPlatform.isLinux,
}:

let
  stdenv = if withMold then useMoldLinker clangStdenv else clangStdenv;
in
rustPlatform.buildRustPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "codediff";
  version = "0.28.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kI/dGVlKc0XcAViCP8kzuqE90YEaKZ1eJsncV0esEtw=";
  };

  cargoHash = "sha256-gQKJPoZdV9XtFHbove8NXZEGdwaJQDVeZfrgtYd2iIA=";

  # Build only the shipped binaries; `xtask` is dev-only tooling.
  cargoBuildFlags = [
    "--bin"
    "codediff"
    "--bin"
    "codediff-watcher"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  cargoTestFlags = [
    # Exclude the dev-only xtask crate from the test run.
    # --exclude is a cargo flag (requires --workspace), so it must go here,
    # not in checkFlags (those are passed to the test binary after `--`).
    "--workspace"
    "--exclude=xtask"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The watcher tests fail with "unable to start FSEvent stream",
    # as FSEvents is not available in the darwin sandbox
    "--exclude=watcher"
  ];

  checkFlags = [
    # The build directory is not a git repository, so this test cannot pass
    # in the Nix sandbox.
    "--skip=it_works_on_this_repository"
    # These tests spawn the binary on a real PTY, which is not available
    # in the Nix build sandbox.
    "--skip=terminal::"
  ];

  meta = {
    description = "Terminal reviewer for Git changes";
    homepage = "https://github.com/esmuellert/codediff";
    changelog = "https://github.com/esmuellert/codediff/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.FirelightFlagboy ];
    license = lib.licenses.mit;
    mainProgram = "codediff";
    platforms = lib.platforms.all;
  };
})
