{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "repomix";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    tag = "v${version}";
    hash = "sha256-UZvVXSucx/OrCRFT/esOHjC/XOAxN8buoyGShh8HdYM=";
  };

  npmDepsHash = "sha256-cXD1rs5wLCJdBLPkZiNtDj/EaAc46gbdSmCo6FajcUo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npx vitest run
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to pack repository contents to single file for AI consumption";
    homepage = "https://github.com/yamadashy/repomix";
    changelog = "https://github.com/yamadashy/repomix/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ boralg ];
    mainProgram = "repomix";
  };
}
