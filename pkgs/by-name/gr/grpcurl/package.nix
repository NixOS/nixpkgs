{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-bgjlCK3sTRrz1FhAs7mQbaea2gMS7liLXU6z02FPTfg=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorHash = "sha256-OHU3uoQVui9qnzGi4waOmY9IpTIEGCpdV41CWIIL98E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
    mainProgram = "grpcurl";
  };
}
