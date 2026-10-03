{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "criticalup";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ferrocene";
    repo = "criticalup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FPHnSp6/26NqJE24Qtd7dbpbFkjYL0Jsrs8k0HZE+Ks=";
  };
  cargoHash = "sha256-7sG+qGn2sqawuVFDZ4aXAqxCkBjJdxnts7llJz1o2Hg=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # TODO remove patch with next release after 1.6.0
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/ferrocene/criticalup/pull/184.patch";
      hash = "sha256-zLEF6KYfOglb9o3hqpAEsYAINFnEAWqQ2Jtax+/8jbs=";
    })
  ];

  env.RUSTFLAGS = "--cfg=hyper_unstable_tracing";
  cargoBuildFlags = [ "--package=criticalup" ];

  # This check fails due to being ran in a temporary subdir.
  checkFlags = [ "--skip=run::simple_run_command_did_not_run_install" ];

  meta = {
    description = "Toolchain manager for the safety-critical Rust toolchain Ferrocene, similar to rustup";
    homepage = "https://criticalup.ferrocene.dev/";
    changelog = "https://criticalup.ferrocene.dev/changelog.html";
    license =
      with lib.licenses;
      OR [
        lib.licenses.asl20
        lib.licenses.mit
      ];
    maintainers = with lib.maintainers; [ wucke13 ];
    mainProgram = "criticalup";
    platforms = lib.platforms.all;
  };
})
