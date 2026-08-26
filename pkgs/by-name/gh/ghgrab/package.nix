{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MRELy+iwLt+qbO3ODHHNZcSSAiEtII2hEoMs3Snu+u8=";
  };

  cargoHash = "sha256-Qq4l+BSNlpHrGAUtLXpyNJj0NdGVar+hIfMQPM5b8rU=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/abhixdd/ghgrab/releases/tag/v${finalAttrs.version}";
    description = "Simple, pretty terminal tool that lets you search and download files from GitHub without leaving your CLI";
    homepage = "https://github.com/abhixdd/ghgrab";
    license = lib.licenses.mit;
    mainProgram = "ghgrab";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
