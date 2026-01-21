{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amazon-ecs-agent";
  version = "1.101.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = "amazon-ecs-agent";
    hash = "sha256-bD+gA9uPtHNDcg/QC+O9sQk7G4und5dViqS6f7pV0rU=";
  };

  vendorHash = null;

  modRoot = "./agent";

  excludedPackages = [ "./version/gen" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage = "https://github.com/aws/amazon-ecs-agent";
    changelog = "https://github.com/aws/amazon-ecs-agent/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "agent";
  };
}
