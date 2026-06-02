{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pulumictl";
  version = "0.0.50";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Jq7H2lM5Vu/cb+mgoUP6p8MQxJ3w0Pgt+adWey2mPKk=";
  };

  vendorHash = "sha256-sgI6kpmVofG1yCVH6rWtb7Owoxlypp4we/gPfIGa6sM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumictl/pkg/version.Version=${finalAttrs.src.rev}"
  ];

  subPackages = [ "cmd/pulumictl" ];

  meta = {
    description = "Swiss Army Knife for Pulumi Development";
    mainProgram = "pulumictl";
    homepage = "https://github.com/pulumi/pulumictl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vincentbernat ];
  };
})
