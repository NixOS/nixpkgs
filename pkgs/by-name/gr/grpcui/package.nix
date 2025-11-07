{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grpcui";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcui";
    rev = "v${version}";
    sha256 = "sha256-mZeNK/NwN887TN4fnvGzrqwJCBYnYcuW/K+O0LgX0uo=";
  };

  vendorHash = "sha256-y4OK610q+8m48M/HX3bXNV7YguoOaZKnCw+JnEvqbEI=";

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "grpcui";
  };
}
