{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-health-probe";
  version = "0.4.42";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${version}";
    hash = "sha256-/7Xxti2QOClWRo6EwHRb369+x/NeT6LHhDDyIJSHv00=";
  };

  vendorHash = "sha256-9NDSkfHUa6xfLByjtuDMir2UM5flaKhD6jZDa71D+0w=";

  meta = with lib; {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
    mainProgram = "grpc-health-probe";
  };
}
