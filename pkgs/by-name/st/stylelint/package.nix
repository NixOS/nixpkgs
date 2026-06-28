{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.14.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-xAH0irfayof45P6M5zdmMGofd0NKu23qHoPm+7wf8IE=";
  };

  npmDepsHash = "sha256-QgknQ4JoZATVAzAuPHQ4RHtX72AsrTseHCUd1Yp4DiM=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
