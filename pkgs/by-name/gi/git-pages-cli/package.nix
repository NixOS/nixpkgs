{
  buildGoModule,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages-cli";
  version = "1.13.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "git-pages";
    repo = "git-pages-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HlK5fu2i9ucU0nHOkynVZjVOs6POObKt2CSBmBb4ObQ=";
  };

  vendorHash = "sha256-z8z47t/SR7hH+dLfRPOKu/QEUPgldfnQ33vHbWN8Uew=";

  ldflags = [
    "-X"
    "main.versionOverride=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
  };

  meta = {
    description = "Command-line application for uploading a site to a git-pages server";
    homepage = "https://codeberg.org/git-pages/git-pages-cli";
    changelog = "https://codeberg.org/git-pages/git-pages-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd0;
    mainProgram = "git-pages-cli";
    maintainers = with lib.maintainers; [ dramforever ];
  };
})
