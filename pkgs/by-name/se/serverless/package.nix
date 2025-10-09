{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "serverless";
  version = "3.38.0";

  src = fetchFromGitHub {
    owner = "serverless";
    repo = "serverless";
    rev = "v${version}";
    hash = "sha256-DplJRJOdIpZfIvpyPo9VcaXCHVPWB8FwhOH4vISUh3Q=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-k5/oTINK/G+wtuANAEDTai2mDNPYvsocUokIswuYrRM=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/serverless/serverless/blob/${src.rev}/CHANGELOG.md";
    description = "Build applications on AWS Lambda and other next-gen cloud services, that auto-scale and only charge you when they run";
    homepage = "https://serverless.com";
    license = lib.licenses.mit;
    mainProgram = "serverless";
    maintainers = [ ];
  };
}
