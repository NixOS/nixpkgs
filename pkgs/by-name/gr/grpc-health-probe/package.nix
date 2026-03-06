{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
  version = "0.4.46";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+HLYlC0B97iI0Z0bJ1bLTVGi/VtynKmmLBnlS3KcpXY=";
  };

  tags = [
    "netgo"
  ];

  ldflags = [
    "-w"
    "-X main.versionTag=${finalAttrs.version}"
  ];

  vendorHash = "sha256-4JvUAA1yt9s3pSEGtP7TY96rco64yaNnGC9ZlyzKM5g=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    changelog = "https://github.com/grpc-ecosystem/grpc-health-probe/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
    mainProgram = "grpc-health-probe";
  };
})
