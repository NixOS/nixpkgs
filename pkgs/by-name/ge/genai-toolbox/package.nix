{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "genai-toolbox";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "genai-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3J9JcEHgds1u+VbNU1BjQOoo1368OxX5ulP18XqE0Sc=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-1K+yCP5AzZ3uPxS3u3BtW0vpKsMkz8mGZUmUD1R9Lkk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

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
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "genai-toolbox";
  };
})
