{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jmespath";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jmespath";
    repo = "go-jmespath";
    rev = "v${version}";
    sha256 = "sha256-djA/7TCmAqCsht28b1itoiWd8Mtdsn/5uLxyT23K/qM=";
  };

  vendorHash = "sha256-Q12muprcKB7fCxemESb4sGPyYIdmgOt3YXVUln7oabw=";

  excludedPackages = [
    "./internal/testify"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    description = "Golang implementation of JMESPath";
    homepage = "https://github.com/jmespath/go-jmespath";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cransom ];
=======
  meta = with lib; {
    description = "Golang implementation of JMESPath";
    homepage = "https://github.com/jmespath/go-jmespath";
    license = licenses.asl20;
    maintainers = with maintainers; [ cransom ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "jpgo";
  };
}
