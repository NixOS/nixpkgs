{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "crd2pulumi";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0D5U3Ie9h5R0kTLb5YHshtYrwuoXxPX0fYAJGqUw35w=";
  };

  vendorHash = "sha256-mO1DgyasJFYpRxeTd8Dinn1mcddCjTiUqs54WD31V/w=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/crd2pulumi/gen.Version=${finalAttrs.src.rev}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    mainProgram = "crd2pulumi";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
