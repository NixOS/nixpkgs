{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  git,
  R,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rv";
  version = "0.23.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "A2-ai";
    repo = "rv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JH5FaNoKCj0q5x1YmnqgOfq6t1lOBZ1bmDKteWVS918=";
  };

  cargoHash = "sha256-p94UXGR5dsfL11QcRytiryAAxYIt96sjXOCDIl/ym0A=";

  buildFeatures = [ "cli" ];

  # `R` in `buildInputs` lets its setup hook populate `R_LIBS_SITE`; `R` in
  # `nativeCheckInputs` puts `R` on `PATH` for the `rv run` tests.
  buildInputs = [
    openssl
    R
  ];

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [
    git
    R
    writableTmpDirAsHomeHook
  ];

  cargoTestFlags = [ "--no-fail-fast" ];

  # These integration tests download a CRAN/Posit package index or clone a git
  # repository, which the build sandbox disallows.
  checkFlags = [
    "--skip=run_self_contained_ignores_ambient_project"
    "--skip=run_self_contained_works"
    "--skip=test_cache_with_global_set"
    "--skip=test_invalid_global_cache_path"
    "--skip=test_summary_with_global_set"
  ];

  preCheck = ''
    export TERM=xterm-256color
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reproducible R package manager written in Rust";
    homepage = "https://github.com/A2-ai/rv";
    changelog = "https://github.com/A2-ai/rv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rv";
    maintainers = [ lib.maintainers.brancengregory ];
  };
})
