{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "repomix";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    tag = "v${version}";
    hash = "sha256-AOqGmI5hnDA18/+uFGQwVKdLniOvGMEBKHTZJa5gE2w=";
  };

  npmDepsHash = "sha256-R/NTlU5ljwmoGHB/5wPADkGx8xjfF4d2bPWWkAr+VOk=";

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
