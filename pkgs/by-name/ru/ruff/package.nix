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
  ruff-lsp,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = version;
    hash = "sha256-xKlvj+8ox5UdkH3s9IOIMOVPCDQMLnGUKDOhKAZZgg4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m9U4OFefSumTT6heNz4qOdRBhsJvP3wcXeZcMVD+NqA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ruff \
        --bash <(${emulator} $out/bin/ruff generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ruff generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ruff generate-shell-completion zsh)
    '';

  # Run cargo tests
  checkType = "debug";

  # tests do not appear to respect linker options on doctests
  # Upstream issue: https://github.com/rust-lang/cargo/issues/14189
  # This causes errors like "error: linker `cc` not found" on static builds
  doCheck = !stdenv.hostPlatform.isStatic;

  # Failing on darwin for an unclear reason, but probably due to sandbox.
  # According to the maintainers, those tests are from an experimental crate that isn't actually
  # used by ruff currently and can thus be safely skipped.
  cargoTestFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--workspace"
    "--exclude=red_knot"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests =
      {
        inherit ruff-lsp;
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        nixos-test-driver-busybox = nixosTests.nixos-test-driver.busybox;
      };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python linter and code formatter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
    maintainers = with lib.maintainers; [
      figsoda
      GaetanLepage
    ];
  };
}
