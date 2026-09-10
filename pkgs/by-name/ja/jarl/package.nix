{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jarl";
  version = "0.6.0-unstable-2026-08-30"; # TODO revert unstable with next version

  src = fetchFromGitHub {
    owner = "etiennebacher";
    repo = "jarl";
    rev = "0abcc17f335010419fa9cae463d746ad1343477e";
    hash = "sha256-zUOCHL/AKDzOmWbnpP6BccEJ+tmtRvI1vQ+T/sCnXvY=";
  };

  postPatch = ''
    # Nix sandbox uses build/.tmp as temp dir
    substituteInPlace crates/jarl/tests/integration/helpers/command_ext.rs \
    --replace-fail '(?:/private)?/(?:tmp|var/folders/[^/]+/[^/]+/T)/' \
                   '(?:/nix)?/(?:build)/(?:nix[\-0-9]+/)?'
  '';

  cargoHash = "sha256-TnpkGOs8/IFJ1trzMijOTmX3BR2P3GsBhyv0GVCwHsc=";

  # integrations test require git at build time (jarl >= 0.5.0)
  nativeBuildInputs = [ git ];

  # Don't run integration_tests for jarl-lsp, because it doesn't see
  # the CARGO_BIN_EXE_jarl env var even if exported in preCheck
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--test"
    "integration"
    # "--test integration_tests"
  ];

  doInstallCheck = true;

  postInstall = ''
    rm $out/bin/xtask_codegen
  '';

  meta = {
    description = "Just another R linter";
    homepage = "https://jarl.etiennebacher.com";
    changelog = "https://jarl.etiennebacher.com/changelog";
    mainProgram = "jarl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
})
