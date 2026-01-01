{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jarl";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "etiennebacher";
    repo = "jarl";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-bfN6HkrGzONbJJzJNDan+txh4eSqLDMJtlRutZHzcCs=";
=======
    hash = "sha256-ioX2Vh/uQ+VT/gra+DruG0tMOiobEkbcioeucJHBLfQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # Nix sandbox uses build/.tmp as temp dir
    substituteInPlace crates/jarl/tests/integration/helpers/command_ext.rs \
    --replace-fail '(?:/private)?/(?:tmp|var/folders/[^/]+/[^/]+/T)/' \
                   '(?:/nix)?/(?:build)/(?:nix[\-0-9]+/)?'
  '';

<<<<<<< HEAD
  cargoHash = "sha256-4pXIbrwtSwRfBgS1XGj/X25bgrLuMTYqlFlhRPEw6o4=";
=======
  cargoHash = "sha256-QdOd/l3FNMaVahGo35hdOMel2GDYcf8ZctkwG00KiNM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
