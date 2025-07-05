{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "genai-toolbox";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "genai-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rJjR7Lt6Y1oPhlspoidVxHercDgyYjfvxFtmLsWUDts=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-0oqQBUgQogZoKGlPDlozhooPFoHEBq+Bn1I0MnKWQZ0=";

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
    description = "Open source MCP server for databases";
    homepage = "https://github.com/googleapis/genai-toolbox";
    changelog = "https://github.com/googleapis/genai-toolbox/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "genai-toolbox";
  };
})
