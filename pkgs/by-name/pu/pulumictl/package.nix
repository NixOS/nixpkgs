{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.47";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-bZ7Di1DcvGECfOzW72QnfWRn76U+agsNsdsprBjx5Rw=";
  };

  vendorHash = "sha256-QYQk36e7NLZnl00fRW4i4UMy7jFVaGHlXcxXt/wqw3M=";

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
