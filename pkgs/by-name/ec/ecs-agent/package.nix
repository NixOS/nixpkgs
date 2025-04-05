{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amazon-ecs-agent";
  version = "1.91.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = pname;
    hash = "sha256-7f1qJ9dgouhj+DGikdIzUREPraAA/1y/5lYA8fbIoJo=";
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
    maintainers = with maintainers; [ copumpkin ];
    mainProgram = "agent";
  };
}
