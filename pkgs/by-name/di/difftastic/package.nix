{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-w4z1ljIjPQQYPpMGgrcptTYeP5S72iVvVgNvrctN61w=";
  };

  cargoHash = "sha256-qj2CyHlEVxTo3wsmuivpnhx02/gMbZjmpAM3dp4xXEQ=";

  env = lib.optionalAttrs stdenv.hostPlatform.isStatic { RUSTFLAGS = "-C relocation-model=static"; };

  # skip flaky tests
  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/difft";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ethancedwards8
      figsoda
      matthiasbeyer
      defelo
    ];
    mainProgram = "difft";
  };
})
