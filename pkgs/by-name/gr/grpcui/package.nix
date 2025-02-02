{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "grpcui";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yk9SgQMUga7htP7XTKFk2JGzixxBV3y3PrnkzsiAMbw=";
  };

  vendorHash = "sha256-uP5jtFji2E6GqpzjD7X5p59TXu7KQVBgEX+Gh0BIclM=";

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
