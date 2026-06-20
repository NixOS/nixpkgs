{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aws-codeartifact-proxy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sktan";
    repo = "aws-codeartifact-proxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iCUnlpQBXMI99gYE/YqNHq0pMsjHaB8BR2HV5GZwPi4=";
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-pBKVg4h2Ta99ekQHNwaVjlTp6YhKa5tsq3zw1y4/IU0=";

  meta = {
    description = "AWS CodeArtifact proxy to allow unauthenticated read access";
    homepage = "https://github.com/sktan/aws-codeartifact-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "aws-codeartifact-proxy";
  };
})
