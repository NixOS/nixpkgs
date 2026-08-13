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
  version = "0.70.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-AqdvPL5VL7H+h1RvGP7613pIHRIK3PEYdtHs1PTiPZw=";
  };

  cargoHash = "sha256-sF1/bITwmIE2VT769aUgSgVaB059pGspjnMi4Ksx7dY=";

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
