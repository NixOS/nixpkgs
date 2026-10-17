{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WdDMgYnC12E2SVe46WiZFTvgVYiW/7JGQJb/hKom/DE=";
  };

  cargoHash = "sha256-EArsqK0N6TibqhTBopn1Q7nGHfX2Qt88lCJkEz5Cuuc=";

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
