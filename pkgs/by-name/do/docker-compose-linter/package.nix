{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "docker-compose-linter";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "zavoloklom";
    repo = "docker-compose-linter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bHu6EtMeMFrhR0oZYGCG/fd26FGO1JlBMDU8kd2xio4=";
  };

  npmDepsHash = "sha256-N9UiemBlFz88EAdbTazz29YQQGxG3ZYX1tRxhQkEMsE=";

  nativeBuildInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for validating and enforcing best practices in Docker Compose files";
    homepage = "https://github.com/zavoloklom/docker-compose-linter";
    changelog = "https://github.com/zavoloklom/docker-compose-linter/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    platforms = lib.platforms.all;
    mainProgram = "dclint";
  };
})
