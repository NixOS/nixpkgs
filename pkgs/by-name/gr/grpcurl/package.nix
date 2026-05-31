{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpcurl";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bgjlCK3sTRrz1FhAs7mQbaea2gMS7liLXU6z02FPTfg=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorHash = "sha256-OHU3uoQVui9qnzGi4waOmY9IpTIEGCpdV41CWIIL98E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knl ];
    mainProgram = "grpcurl";
  };
})
