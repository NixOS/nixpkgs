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
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-uQQ/UbmyPJbilxP2R+6KyBkf2dzGohN22xCCtU31y0s=";
  };

  cargoHash = "sha256-F2zHGlIaSGWcw67AIOa3N0AbKMVGQukUECZxCte7qlE=";

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
    description = "A CLI tool to pretty print SARIF diagnostics";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "sarif-fmt";
  };
}
