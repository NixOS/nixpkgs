{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-BxWCSkSeDyiiGBY2u0ahPrIhYq2lbujoPPtZGq/OkI0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kIqaZ8truDivMV6uo1+j9bmXQReREZjHSr89ZvVDWCw=";

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
