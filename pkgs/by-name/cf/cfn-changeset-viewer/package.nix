{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "cfn-changeset-viewer";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "cfn-changeset-viewer";
    tag = version;
    hash = "sha256-RTGKt8Mq0v3zIFZWTeAV+nDlegw0p9b19wpB/BfQGQk=";
  };

  npmDepsHash = "sha256-NyWZ+8ArlUCsuBN5wZA9vnuX/3HFtuI42/V1+RIKom0=";

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to view the changes calculated in a CloudFormation ChangeSet in a more human-friendly way";
    homepage = "https://github.com/trek10inc/cfn-changeset-viewer";
    license = lib.licenses.mit;
    mainProgram = "cfn-changeset-viewer";
    maintainers = with lib.maintainers; [ surfaceflinger ];
  };
}
