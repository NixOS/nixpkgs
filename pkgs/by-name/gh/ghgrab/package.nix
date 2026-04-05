{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ea5JdOKu4LBD77Nlj9gmISb6GPDhOZc3XCrRj2X/cB0=";
  };

  cargoHash = "sha256-S1wkdPYVvH+4rfCQ/IohrqvHsiVWlb9OW5Dva3jNeis=";

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
