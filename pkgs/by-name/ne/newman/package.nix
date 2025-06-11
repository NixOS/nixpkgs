{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    tag = "v${version}";
    hash = "sha256-p0/uHrLiqw5VnboXzLKF+f56ZfW77m5aoopf2zqIpQE=";
  };

  npmDepsHash = "sha256-HQ5V0hisolXqWV/oWlroCzC7ZoNw0P9bwTxFyUrL3Hc=";

  dontNpmBuild = true;

  meta = {
    homepage = "https://www.getpostman.com";
    description = "Command-line collection runner for Postman";
    mainProgram = "newman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.asl20;
  };
}
