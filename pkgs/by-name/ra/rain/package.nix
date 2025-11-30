{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${version}";
    sha256 = "sha256-3Otjy6cZBEUCJI9l0B1+pL3/qmLI9PjPTl3Wd/mhaIE=";
  };

  vendorHash = "sha256-Egh7NzjHHgQATezlqFOk6FjUwhvtM0MJqCUJTDeHZG0=";

  subPackages = [ "cmd/rain" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
