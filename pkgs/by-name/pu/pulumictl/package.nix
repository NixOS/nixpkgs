{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.48";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-rFVxfWeESWmqH0BhKY6BO5AxSPXVW8tOPGyUXB5Kc/E=";
  };

  vendorHash = "sha256-x5CBSzwOfX0BwwbAOuW1ibrLnnkVSNjqG0Sj2EcmRbM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumictl/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/pulumictl" ];

  meta = with lib; {
    description = "Swiss Army Knife for Pulumi Development";
    mainProgram = "pulumictl";
    homepage = "https://github.com/pulumi/pulumictl";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
