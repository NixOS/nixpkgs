{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,

  rust-jemalloc-sys,
  buildPackages,
  versionCheckHook,

  # passthru
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruff";
  version = "0.12.8";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = finalAttrs.version;
    hash = "sha256-ypYtAUQBFSf+cgly9K5eRMegtWrRmLmqrgfRmCJvXEk=";
  };

  # Patch out test that fails due to ANSI escape codes being written as-is,
  # causing a snapshot test to fail. The output itself is correct.
  #
  # This is the relevant test's output as of 0.12.5
  # >     0       │-/home/ferris/project/code.py:1:1: E902 Permission denied (os error 13)
  # >     1       │-/home/ferris/project/notebook.ipynb:1:1: E902 Permission denied (os error 13)
  # >     2       │-/home/ferris/project/pyproject.toml:1:1: E902 Permission denied (os error 13)
  # >           0 │+␛[1m/home/ferris/project/code.py␛[0m␛[36m:␛[0m1␛[36m:␛[0m1␛[36m:␛[0m ␛[1m␛[31mE902␛[0m Permission denied (os error 13)
  # >           1 │+␛[1m/home/ferris/project/notebook.ipynb␛[0m␛[36m:␛[0m1␛[36m:␛[0m1␛[36m:␛[0m ␛[1m␛[31mE902␛[0m Permission denied (os error 13)
  # >           2 │+␛[1m/home/ferris/project/pyproject.toml␛[0m␛[36m:␛[0m1␛[36m:␛[0m1␛[36m:␛[0m ␛[1m␛[31mE902␛[0m Permission denied (os error 13)
  # > ────────────┴───────────────────────────────────────────────────────────────────
  postPatch = ''
    substituteInPlace crates/ruff/src/commands/check.rs --replace-fail '
        #[test]
        fn unreadable_files() -> Result<()> {' \
    '
        #[test]
        #[ignore = "ANSI Escape Codes trigger snapshot diff"]
        fn unreadable_files() -> Result<()> {'
  '';

  cargoBuildFlags = [ "--package=ruff" ];

  cargoHash = "sha256-0iYwS8Ssi4JDxwr0Q2+iKvYHb179L6BiiuXa2D4qiOA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ruff \
        --bash <(${emulator} $out/bin/ruff generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ruff generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ruff generate-shell-completion zsh)
    ''
  );

  # Run cargo tests
  checkType = "debug";

  # tests do not appear to respect linker options on doctests
  # Upstream issue: https://github.com/rust-lang/cargo/issues/14189
  # This causes errors like "error: linker `cc` not found" on static builds
  doCheck = !stdenv.hostPlatform.isStatic;

  # Exclude tests from `ty`-related crates, run everything else.
  # Ordinarily we would run all the tests, but there is significant overlap with the `ty` package in nixpkgs,
  # which ruff shares a monorepo with.
  # As such, we leave running `ty` tests to the `ty` package, and concentrate on everything else.
  cargoTestFlags = [
    "--workspace"
    "--exclude=ty"
    "--exclude=ty_ide"
    "--exclude=ty_project"
    "--exclude=ty_python_semantic"
    "--exclude=ty_server"
    "--exclude=ty_static"
    "--exclude=ty_test"
    "--exclude=ty_vendored"
    "--exclude=ty_wasm"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      nixos-test-driver-busybox = nixosTests.nixos-test-driver.busybox;
    };
    # Updating `ruff` needs to be done on staging due to NixOS tests. Disabling r-ryantm update bot:
    # nixpkgs-update: no auto update
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python linter and code formatter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
    maintainers = with lib.maintainers; [
      bengsparks
      figsoda
      GaetanLepage
    ];
  };
})
