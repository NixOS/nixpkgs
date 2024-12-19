{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-codeartifact-proxy";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "sktan";
    repo = "aws-codeartifact-proxy";
    rev = "v${version}";
    hash = "sha256-289iYPI8J64nRa0PTf47/FQAEqA+rTzalz6S71vFLzs=";
  };
  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-3MO+mRCstXw0FfySiyMSs1vaao7kUYIyJB2gAp1IE48=";

  meta = {
    description = "AWS CodeArtifact proxy to allow unauthenticated read access";
    homepage = "https://github.com/sktan/aws-codeartifact-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "aws-codeartifact-proxy";
  };
}
