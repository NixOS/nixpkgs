{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "crd2pulumi";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0BnDN1D1g/LdYqLw1It5a/jG2g6/kBb4F64NEI5xFeA=";
  };

  vendorHash = "sha256-cbJ0jZtJhVz3b1jdsLiwNBHqRUHk29haJ+YzShcTfJg=";

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
