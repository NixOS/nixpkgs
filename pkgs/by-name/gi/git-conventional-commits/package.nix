{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "2.9.0";
in
buildNpmPackage {
  pname = "git-conventional-commits";
  inherit version;

  src = fetchFromGitHub {
    owner = "qoomon";
    repo = "git-conventional-commits";
    tag = "v${version}";
    hash = "sha256-Mt99QTrWv+uuThL7tyM2wyOFj6/MrSKXg5ai0RNyyDE=";
  };

  npmDepsHash = "sha256-6Dgf6wx0G0Ev8IPrgHU/dTdRNvrtKa+Shdvv1IJolN4=";

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/qoomon/git-conventional-commits";
    description = "Generate semantic versions, markdown changelogs, and validate commit messages";
    changelog = "https://github.com/qoomon/git-conventional-commits/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yzx9 ];
    mainProgram = "git-conventional-commits";
  };
}
