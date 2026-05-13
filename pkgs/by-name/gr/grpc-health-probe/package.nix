{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
  version = "0.4.49";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JH4Km8nlUffkga7oKgXXwqRYm/8oG9giLCFn1BZ1eVY=";
  };

  tags = [
    "netgo"
  ];

  ldflags = [
    "-w"
    "-X main.versionTag=${finalAttrs.version}"
  ];

  vendorHash = "sha256-97OFqr93G/6F58nF1riGFbCOtORPojMMU4IX9ivjSxg=";

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
