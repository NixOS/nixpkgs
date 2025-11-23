{
  buildGoModule,
  fetchFromGitea,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages-cli";
  version = "1.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "git-pages";
    repo = "git-pages-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uwp7/l4AsVwKPWKkPjPJqPqR7f+N4ksgq44HctLBiGo=";
  };

  vendorHash = "sha256-5vjUhN3lCr41q91lOD7v0F9c6a8GJj7wBGnnzgFBhJU=";

  ldflags = [
    "-X"
    "main.versionOverride=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line application for uploading a site to a git-pages server";
    homepage = "https://codeberg.org/git-pages/git-pages-cli";
    changelog = "https://codeberg.org/git-pages/git-pages-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd0;
    mainProgram = "git-pages-cli";
    maintainers = with lib.maintainers; [ dramforever ];
  };
})
