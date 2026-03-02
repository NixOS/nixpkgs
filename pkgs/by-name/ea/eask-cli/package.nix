{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "eask-cli";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-jYdx+MYgUop01MzcKPxtm+ZW6lsy9eCqH00uQd8imRw=";
  };

  npmDepsHash = "sha256-Xj68un97I8xtAY3RXEq8PNC8ZOZ+NWg6SblnmKzHGMo=";

  dontBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/emacs-eask/cli/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "CLI for building, runing, testing, and managing your Emacs Lisp dependencies";
    homepage = "https://emacs-eask.github.io/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eask";
    maintainers = with lib.maintainers; [
      jcs090218
      piotrkwiecinski
    ];
  };
})
