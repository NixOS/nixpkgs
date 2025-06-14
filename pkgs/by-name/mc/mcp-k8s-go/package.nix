{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-k8s-go";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "strowk";
    repo = "mcp-k8s-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6DKhcUwXBap7Ts+T46GJJxKS6LXTfScZZEQV0PhuVfQ=";
  };

  # remove e2e tests
  postPatch = ''
    rm -rf main_test.go
  '';
  vendorHash = "sha256-ZThUxmfh0/cDFIzREO89qYPAWVuEmTBvxAB+3AJ/VyA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "MCP server connecting to Kubernetes";
    homepage = "https://github.com/strowk/mcp-k8s-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-k8s-go";
  };
})
