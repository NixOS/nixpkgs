{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "amazon-ecs-agent";
  version = "1.101.2";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "aws";
    repo = "amazon-ecs-agent";
    hash = "sha256-J4gjkULtkU1LMHBNcm/QQ407uWMZ6jREP9MdSK0Js44=";
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
    changelog = "https://github.com/aws/amazon-ecs-agent/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "agent";
  };
})
