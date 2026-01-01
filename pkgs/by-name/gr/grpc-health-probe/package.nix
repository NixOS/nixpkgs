{
  buildGoModule,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
<<<<<<< HEAD
  version = "0.4.43";
=======
  version = "0.4.42";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-xmNqo+Wa/58944v52MAtFCy9G0LJVIn/XGG7JYqcCvM=";
=======
    hash = "sha256-/7Xxti2QOClWRo6EwHRb369+x/NeT6LHhDDyIJSHv00=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  tags = [
    "netgo"
  ];

  ldflags = [
    "-w"
    "-X main.versionTag=${finalAttrs.version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-WGY4vj1a+sOKKmuY+1RD/GPOKIUunfdBor0xG64IJY8=";
=======
  vendorHash = "sha256-9NDSkfHUa6xfLByjtuDMir2UM5flaKhD6jZDa71D+0w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

<<<<<<< HEAD
  meta = {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    changelog = "https://github.com/grpc-ecosystem/grpc-health-probe/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
=======
  meta = with lib; {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    changelog = "https://github.com/grpc-ecosystem/grpc-health-probe/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "grpc-health-probe";
  };
})
