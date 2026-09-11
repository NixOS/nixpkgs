{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "hum";
  __structuredAttrs = true;
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "brettinternet";
    repo = "hum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTz8m5Q9FPXLhGcZx6EMay9LSMS+vmeifr0raHrXGAw=";
  };

  vendorHash = "sha256-LcjnSZjiTQm41Qv4dtvkbWJUr8EKkYK52nClRv02Alg=";

  subPackages = [ "cmd/hum" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${finalAttrs.version}"
    "-X main.buildTime=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Process supervisor for development workflows and coding agents";
    homepage = "https://github.com/brettinternet/hum";
    changelog = "https://github.com/brettinternet/hum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brettinternet ];
    mainProgram = "hum";
  };
})
