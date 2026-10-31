{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "dclint";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "zavoloklom";
    repo = "docker-compose-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHu6EtMeMFrhR0oZYGCG/fd26FGO1JlBMDU8kd2xio4=";
  };

  npmDepsHash = "sha256-N9UiemBlFz88EAdbTazz29YQQGxG3ZYX1tRxhQkEMsE=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "A command-line tool for validating and enforcing best practices in Docker Compose files";
    longDescription = ''
      Docker Compose Linter (DCLint) is a utility designed to analyze,
      validate and fix Docker Compose files. It helps identify errors,
      style violations, and potential issues, ensuring your configurations are robust,
      maintainable, and free from common pitfalls.
    '';
    homepage = "https://github.com/zavoloklom/docker-compose-linter";
    changelog = "https://github.com/zavoloklom/docker-compose-linter/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/zavoloklom/docker-compose-linter/releases";
    license = lib.licenses.mit;
    mainProgram = "dclint";
    maintainers = with lib.maintainers; [ MH0386 ];
  };
})
