{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stax";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "stax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HHunRVDoijBOcIzj0xknj2O+m+A1nmkkxu97XZcvmJw=";
  };

  nativeBuildInputs = [ perl ];

  cargoHash = "sha256-cJmK5uX3HCz4own2UtXFkHdGFETjina2/UW18f/g/bA=";

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
