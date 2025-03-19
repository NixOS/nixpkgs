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

  meta = with lib; {
    description = "JMESPath implementation in Go";
    homepage = "https://github.com/jmespath/go-jmespath";
    license = licenses.asl20;
    maintainers = with maintainers; [ cransom ];
    mainProgram = "jpgo";
  };
}
