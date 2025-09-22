{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${version}";
    sha256 = "sha256-B6eaoyYROF8LB5vO1qMqXYtBF8vvJE8xygarW2+GSpA=";
  };

  vendorHash = "sha256-ASiC/SXwaJ1xHlhPcVS9JsGcfRP6/fonq+ZIBehZgho=";

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
