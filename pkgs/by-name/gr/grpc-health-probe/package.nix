{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
  version = "0.4.42";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/7Xxti2QOClWRo6EwHRb369+x/NeT6LHhDDyIJSHv00=";
  };

  tags = [
    "netgo"
  ];

  ldflags = [
    "-w"
    "-X main.versionTag=${finalAttrs.version}"
  ];

  vendorHash = "sha256-9NDSkfHUa6xfLByjtuDMir2UM5flaKhD6jZDa71D+0w=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = with lib; {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    changelog = "https://github.com/grpc-ecosystem/grpc-health-probe/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
    mainProgram = "grpc-health-probe";
  };
})
