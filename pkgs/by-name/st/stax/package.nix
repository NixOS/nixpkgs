{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stax";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "stax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8LIc0/z6HJuej9VWMqpW9RTu/kGDQHN59vopDr+iF6w=";
  };

  nativeBuildInputs = [ perl ];

  cargoHash = "sha256-lOQzFz579p89hDBh3Z7oO2iTITpJG9fFqW/rEq8DwJ0=";

  doInstallCheck = true;
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Stacked-branch workflow for Git with an interactive TUI, smart PRs, and safe undo";
    homepage = "https://github.com/cesarferreira/stax";
    license = lib.licenses.mit;
    mainProgram = "stax";
    maintainers = with lib.maintainers; [
      henrikvtcodes
    ];
  };
})
