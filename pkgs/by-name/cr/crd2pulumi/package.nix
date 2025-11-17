{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-f18E0mUE3bT5od0JBzyAEXOHymoPtpRHeZhZnQR4Ezw=";
  };

  vendorHash = "sha256-cLp0EWF6h/xCWbqadpbgLRFmH8RKWoY6xPb/tzZoKzM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    mainProgram = "crd2pulumi";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
