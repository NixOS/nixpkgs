{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "genai-toolbox";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "genai-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hQNOlMeR8yHwfNd9hYJBY0XHFU6Q8kTWJ2diZdxzrY8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-Ltl/SoTEq3pMdc16+PU7cWGIXX6bO05TiMGRIV7tF6g=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # some tests (e.g. valkey_test.go) require network access/a valkey database
  doCheck = false;

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Open-source MCP server for databases";
    homepage = "https://github.com/googleapis/genai-toolbox";
    changelog = "https://github.com/googleapis/genai-toolbox/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "genai-toolbox";
  };
})
