{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  bashNonInteractive,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-parallel";
  version = "1.22.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aaronriekenberg";
    repo = "rust-parallel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6SDWYIJDoDKANYZvYM2hdFzXTyqbfRA2uKQDFn+6erg=";
  };

  cargoHash = "sha256-uFx0Sli6uwmhHKQoT1aX0S5NwuWLu3M6g5pQYYpAsEI=";

  checkInputs = [ bashNonInteractive ];

  # Some test require the output of tracing which for some reason hides info if RUST_LOG is set to "" which it is by default
  logLevel = "info";

  preCheck = ''
    patchShebangs ./tests/dummy_shell.sh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust shell tool to run commands in parallel with a similar interface to GNU parallel";
    homepage = "https://github.com/aaronriekenberg/rust-parallel";
    license = lib.licenses.mit;
    mainProgram = "rust-parallel";
    maintainers = with lib.maintainers; [ sedlund ];
  };
})
