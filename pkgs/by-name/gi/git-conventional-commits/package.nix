{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "2.7.2";
in
buildNpmPackage {
  pname = "git-conventional-commits";
  inherit version;

  src = fetchFromGitHub {
    owner = "qoomon";
    repo = "git-conventional-commits";
    tag = "v${version}";
    hash = "sha256-3X5AnpIzqszKjMqFgUr9wzyzDpnRJ94hcBJpQ8J9H/c=";
  };

  npmDepsHash = "sha256-XUDWvoJTpOQZCUyYbijD/hA1HVseHO19vAheJrPd1Gk=";

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

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
