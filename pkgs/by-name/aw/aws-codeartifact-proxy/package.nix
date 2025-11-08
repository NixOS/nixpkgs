{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-codeartifact-proxy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sktan";
    repo = "aws-codeartifact-proxy";
    rev = "v${version}";
    hash = "sha256-dcUJ2r0VBUNk8kKY1fPkUHoJi1fhAQbd2K+9MC/ddGE=";
  };
  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-5D/aKNU7ZtDMJW+KImBwN4bhpSexsldtCtA3IIHJrQU=";

  meta = {
    description = "AWS CodeArtifact proxy to allow unauthenticated read access";
    homepage = "https://github.com/sktan/aws-codeartifact-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "aws-codeartifact-proxy";
  };
}
