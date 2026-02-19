{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-cnpg";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9NfjrVF0OtDLaGD5PPFSZcI8V3Vy/yOTm/JwnE3kMZE=";
  };

  vendorHash = "sha256-QNtKtHTxOgm6EbOSvA2iUE0hjltwTBNkA1mIC3N+AbM=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
  };
})
