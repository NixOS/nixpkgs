{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/WbnpCoyu7oPTrbPro8DHFwZwT6/9tQNgKXeDpmSyEI=";
  };

  cargoHash = "sha256-3ELTmS1kyYvq8bf8sKBDucYQOX20YN5y3hH635W0pCs=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  # tests/github_fetch_test.rs binds to 127.0.0.1
  __darwinAllowLocalNetworking = true;

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
