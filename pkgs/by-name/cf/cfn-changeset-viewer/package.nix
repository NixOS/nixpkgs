{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "cfn-changeset-viewer";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "cfn-changeset-viewer";
    tag = version;
    hash = "sha256-xJ9rPHJRSJivaou1bl/3q51f4IFMjJT1w49GP5Fk98M=";
  };

  npmDepsHash = "sha256-NyWZ+8ArlUCsuBN5wZA9vnuX/3HFtuI42/V1+RIKom0=";

  dontNpmBuild = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
