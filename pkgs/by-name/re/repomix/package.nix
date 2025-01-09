{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "repomix";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    tag = "v${version}";
    hash = "sha256-mtZkp5GZSI/3N0xe3SLaYyHDM+ncnKDjShUqAoUa13s=";
  };

  npmDepsHash = "sha256-F6XbNIzuRyLMQzlOoaRW/x1N4y5WbXS57zzYfhdK/jU=";

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
    maintainers = with lib.maintainers; [ thinnerthinker ];
    mainProgram = "repomix";
  };
}
