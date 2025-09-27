{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-health-probe";
  version = "0.4.40";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${version}";
    hash = "sha256-Na0y8fL109flHGJOniEpLgs60xf1V0YlSBrX9iHtymM=";
  };

  vendorHash = "sha256-eIjDs14PEzoVaRYoxN03pDfYzg4VF1tgskLY9oIkMLE=";

  meta = with lib; {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
    mainProgram = "grpc-health-probe";
  };
}
