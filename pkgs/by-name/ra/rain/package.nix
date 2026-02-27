{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "1.24.2";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xCozToZJRJvebS9H5NH6rHQprgTM3cy0cssJNh9AQmI=";
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
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jiegec ];
  };
})
