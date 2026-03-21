{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-4CkAifz48qLegXTBmXqJe3+LAE1uCUUb28ZgXTVggOk=";
  };

  cargoHash = "sha256-MwoRr8aQAT5plkfapAY2oPrSYYmHGeqxOhCpOMEtUoc=";

  buildInputs = [ rust-jemalloc-sys ];

  env = lib.optionalAttrs stdenv.hostPlatform.isStatic { RUSTFLAGS = "-C relocation-model=static"; };

  # skip flaky tests
  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/difft";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ethancedwards8
      matthiasbeyer
      defelo
    ];
    mainProgram = "difft";
  };
})
