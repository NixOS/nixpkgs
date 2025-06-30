{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "har-to-k6";
  version = "0.14.10";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "har-to-k6";
    tag = "v${version}";
    hash = "sha256-eBy5rBZt9v8XFOSGQPhJWAGy2XuhyuG013A6ex2AxE4=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-RuK3CzcMkPt5MFEZpYBDtMMShHTT/115pRk1CmRkiek=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Converts LI-HAR and HAR to K6 script";
    homepage = "https://github.com/grafana/har-to-k6";
    changelog = "https://github.com/grafana/har-to-k6/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cterence ];
    mainProgram = "har-to-k6";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
