{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sarif-fmt";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Xc9uc//5wTBWJ89mcaC/4c8/xtTvnu8g2Aa1viUhluo=";
  };

  cargoHash = "sha256-h4g4+2yiqr3CTkSgv8fTHEVQwSunFfYFhIczSGA+M5U=";

  # `test_clippy` (the only test we enable) is broken on Darwin
  # because `--enable-profiler` is not enabled in rustc on Darwin
  # error[E0463]: can't find crate for profiler_builtins
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # these tests use nix so...no go
    "--skip=test_clang_tidy"
    "--skip=test_hadolint"
    "--skip=test_shellcheck"

    # requires files not present in the crates.io tarball
    "--skip=test_clipp"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to pretty print SARIF diagnostics";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "sarif-fmt";
  };
}
