{
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "cfn-changeset-viewer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "cfn-changeset-viewer";
    tag = version;
    hash = "sha256-ONgjU07wyC1NoNtTsQO5LbVQiC8gsHqsyYv3Upc0hWQ=";
  };

  npmDepsHash = "sha256-ICaGtofENMaAjk/KGRn8RgpMAICSttx4AIcbi1HsW8Q=";

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "CLI to view the changes calculated in a CloudFormation ChangeSet in a more human-friendly way";
    homepage = "https://github.com/trek10inc/cfn-changeset-viewer";
    license = lib.licenses.mit;
    mainProgram = "cfn-changeset-viewer";
    maintainers = with lib.maintainers; [ surfaceflinger ];
  };
}
