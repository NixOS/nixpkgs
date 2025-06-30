{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-k8s-go";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "strowk";
    repo = "mcp-k8s-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6DKhcUwXBap7Ts+T46GJJxKS6LXTfScZZEQV0PhuVfQ=";
  };

  vendorHash = "sha256-nP9cVXV1qyYancePz1mMNq911Ou7k5nVckQzbM05HpQ=";

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
