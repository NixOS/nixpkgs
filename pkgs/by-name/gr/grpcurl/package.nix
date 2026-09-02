{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpcurl";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Id3F5EEO5qf5kUKKeULX8u7aDIZEw5c1MkP4JMrwc6I=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorHash = "sha256-lUCuP4B+O0S90StTirOmhBncNieZkH4mL9SO2BOogxk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "grpcurl";
  };
})
