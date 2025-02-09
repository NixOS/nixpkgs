{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2yb965fDzNgrPXT2xMRdqD/inyvlwdKlkMj16YSFHBk=";
  };

  vendorHash = "sha256-TlS9SfqMJa5w+JMUx+7ZMF0xk/VsnjOScSGXEw1dVkU=";

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
