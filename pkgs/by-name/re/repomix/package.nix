{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "repomix";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    tag = "v${version}";
    hash = "sha256-vK+Fn9gmPUTWkUHmNAX9OAoGxhG4tiVwqK6P+f8hcJQ=";
  };

  npmDepsHash = "sha256-ihC4SCl0J5trz84ixUq12BjGtPMsfv5Ngs+QzkbjJbQ=";

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
