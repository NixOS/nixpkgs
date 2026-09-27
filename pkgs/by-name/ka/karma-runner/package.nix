{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "karma";
  version = "6.4.4";

  src = fetchFromGitHub {
    owner = "karma-runner";
    repo = "karma";
    tag = "v${version}";
    hash = "sha256-RfEmzUMzgOY6YG0MBheCgwmwOU3C5G8hybH40gLmsr4=";
  };

  npmDepsHash = "sha256-bGtiGLwr9Bmi3Jx2DImpyLhPnxUo7q6YcMCxoxqOkGY=";

  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Spectacular Test Runner for JavaScript";
    homepage = "http://karma-runner.github.io/";
    license = lib.licenses.mit;
    mainProgram = "karma";
    maintainers = [ ];
  };
}
