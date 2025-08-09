{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-codeartifact-proxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sktan";
    repo = "aws-codeartifact-proxy";
    rev = "v${version}";
    hash = "sha256-+P0AIg5m7nePy+Yd445nVfLVxya80Om9lJTPKZeTshc=";
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
