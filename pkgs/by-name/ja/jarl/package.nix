{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jarl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "etiennebacher";
    repo = "jarl";
    tag = finalAttrs.version;
    hash = "sha256-fNGvwgmDzFZGT0mbo9NYiO387QZqfVoOr1NowtEkiCg=";
  };

  postPatch = ''
    # Nix sandbox uses build/.tmp as temp dir
    substituteInPlace crates/jarl/tests/integration/helpers/command_ext.rs \
    --replace-fail '(?:/private)?/(?:tmp|var/folders/[^/]+/[^/]+/T)/' \
                   '(?:/nix)?/(?:build)/(?:nix[\-0-9]+/)?'
  '';

  cargoHash = "sha256-4ciuE3guQuFoe4yV3d1ncFSIcl/1dWYkj2Uk+oQCEdA=";

  # Don't run integration_tests for jarl-lsp, because it doesn't see
  # the CARGO_BIN_EXE_jarl env var even if exported in preCheck
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--test integration"
    # "--test integration_tests"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  postInstall = ''
    rm $out/bin/xtask_codegen
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Just another R linter";
    homepage = "https://jarl.etiennebacher.com";
    changelog = "https://jarl.etiennebacher.com/changelog";
    mainProgram = "jarl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
})
