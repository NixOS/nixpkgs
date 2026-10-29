{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
  version = "0.4.59";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m/v8aYchGabl69+RJhpSNl5sJdvGqCrlLn6+/1fb7xA=";
  };

  tags = [
    "netgo"
  ];

  ldflags = [
    "-w"
    "-X main.versionTag=${finalAttrs.version}"
  ];

  vendorHash = "sha256-c46rSZDEv+uvaq2vaiyB3sfevyp3mDTQTEceFWcMeJI=";

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
