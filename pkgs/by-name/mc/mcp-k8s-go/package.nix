{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-k8s-go";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "strowk";
    repo = "mcp-k8s-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-13FwrG/eqR9bVrQ3CAIY7cFyj+EScWABnKIBo7Pm1w8=";
  };

  vendorHash = "sha256-BPmocRaqqV7p5Yjto3UEbzc2vdlyRSGkdPye3EWXEe4=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "MCP server connecting to Kubernetes";
    homepage = "https://github.com/strowk/mcp-k8s-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-k8s-go";
  };
})
