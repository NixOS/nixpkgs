{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "amazon-ecs-agent";
  version = "1.106.2";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "aws";
    repo = "amazon-ecs-agent";
    hash = "sha256-OMoAsHqcr6DGlRP4PLWmX5RxlpP4UlPQEEpWzmyL9hQ=";
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
