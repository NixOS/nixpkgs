{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "repomix";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    tag = "v${version}";
    hash = "sha256-LmQtgVrWZQFGTxU6Sz6RjPQqVERDWc4A7r6PS0Y7xYc=";
  };

  npmDepsHash = "sha256-C/b/RFMuI5HeVHH24GFupJU1x7Kinoq6tocVHgsWw1w=";

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
