{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "eask-cli";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-5Ii5TEqnlkOO16+IvH+lhYu4ty866ZkWZNLfF0Zqy5Q=";
  };

  npmDepsHash = "sha256-Ou23QiF3P7hflNkN+zWzbu7iLgdYmCDdH0a+OA+/jlk=";

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
