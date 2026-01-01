{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
<<<<<<< HEAD
  version = "1.24.2";
=======
  version = "1.24.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xCozToZJRJvebS9H5NH6rHQprgTM3cy0cssJNh9AQmI=";
=======
    sha256 = "sha256-3Otjy6cZBEUCJI9l0B1+pL3/qmLI9PjPTl3Wd/mhaIE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jiegec ];
=======
  meta = with lib; {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
