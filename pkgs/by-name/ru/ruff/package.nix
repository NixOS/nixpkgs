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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = finalAttrs.version;
    hash = "sha256-Vueccz5lkUTdgqqZl/+PB0kVYezvPKIVxee8EJYcz4g=";
  };

  cargoBuildFlags = [ "--package=ruff" ];

  cargoHash = "sha256-bnSTiQzlZrS2tqQiRHr6gNDq40Naqxrxcyc8zcVlt7A=";

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
