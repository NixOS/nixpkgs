{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-health-probe";
  version = "0.4.41";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    rev = "v${version}";
    hash = "sha256-jAaPdDWCtUj0f6ljxgL4xigo+1mHL6qVPkBkRdgaqVI=";
  };

  vendorHash = "sha256-h1iIkd2cxhqYwFJLIJgexjLwKj1IwR8oYWPpbKGZTXw=";

  meta = with lib; {
    description = "command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
    mainProgram = "grpc-health-probe";
  };
}
