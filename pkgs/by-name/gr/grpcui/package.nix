{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grpcui";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Tmema+cMPDGuX6Y8atow58GdGMj7croHyj8oiDXSEYk=";
  };

  vendorHash = "sha256-a19m+HY6SQ+06LXUDba9KRHRKNxLjzKmldJQaaI6nro=";

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
