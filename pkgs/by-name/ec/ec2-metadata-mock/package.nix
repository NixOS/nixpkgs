{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ec2-metadata-mock";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gqzROHfwhd3i1GWSp58dBKjS1EU7Xu0Fqbzv2PoLaF8=";
  };

  vendorHash = "sha256-Px4vhFW1mhXbBuPbxEpukmeLZewF7zooOXKxL8sEFLU=";

  subPackages = [ "cmd/ec2-metadata-mock" ];

  meta = {
    description = "Amazon EC2 Metadata Mock";
    mainProgram = "ec2-metadata-mock";
    homepage = "https://github.com/aws/amazon-ec2-metadata-mock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ymatsiuk ];
  };
})
