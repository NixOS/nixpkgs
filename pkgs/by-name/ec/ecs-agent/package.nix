{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amazon-ecs-agent";
  version = "1.94.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = "amazon-ecs-agent";
    hash = "sha256-qk1gmR0vI9FnKgJS3nVe8Y4gw+ce5COHj3can4oPb1E=";
  };

  vendorHash = null;

  modRoot = "./agent";

  excludedPackages = [ "./version/gen" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage = "https://github.com/aws/amazon-ecs-agent";
    changelog = "https://github.com/aws/amazon-ecs-agent/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "agent";
  };
}
