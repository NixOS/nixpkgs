{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wg0tDsK29RZ4iunaoLp2IbU4rC7GBlihGWbTJs0l480=";
  };

  cargoHash = "sha256-6B9rVTqA2IoYCYOKy1Dc0f+3YZUJFeFQfEXF1OXZmEQ=";

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
