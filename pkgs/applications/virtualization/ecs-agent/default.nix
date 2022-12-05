{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amazon-ecs-agent";
  version = "1.66.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = pname;
    hash = "sha256-mZzDvD+40YiC8cBpLlYd7K1p5UBYpso9OMCDijopuik=";
  };

  vendorHash = null;

  modRoot = "./agent";

  excludedPackages = [ "./version/gen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "The agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage = "https://github.com/aws/amazon-ecs-agent";
    changelog = "https://github.com/aws/amazon-ecs-agent/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
    mainProgram = "agent";
  };
}

