{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jmespath";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jmespath";
    repo = "go-jmespath";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Golang implementation of JMESPath";
    homepage = "https://github.com/jmespath/go-jmespath";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cransom ];
    mainProgram = "jpgo";
  };
})
