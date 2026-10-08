{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l0uaX31jbbN8zi98l4fdqh/gq8IuHVQNoBcZVzEa50k=";
  };

  cargoHash = "sha256-eJ2W9m33o/j9pRA41c3Iy1QWvMp7OV8sCAY7A97qP3M=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # sends request to a github.com url
    "--skip=test_mcp_repo_info_on_actual_repo"
  ];

  meta = {
    changelog = "https://github.com/abhixdd/ghgrab/releases/tag/v${finalAttrs.version}";
    description = "Simple, pretty terminal tool that lets you search and download files from GitHub without leaving your CLI";
    homepage = "https://github.com/abhixdd/ghgrab";
    license = lib.licenses.mit;
    mainProgram = "ghgrab";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
