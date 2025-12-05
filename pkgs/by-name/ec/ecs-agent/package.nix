{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amazon-ecs-agent";
  version = "1.100.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = "amazon-ecs-agent";
    hash = "sha256-APkYhq4HGxgCNUWaaj5/xK6AwwUZAW4aom48ADd4R7g=";
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
