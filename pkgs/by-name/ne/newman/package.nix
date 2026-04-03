{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    tag = "v${version}";
    hash = "sha256-zp5x/eMF5MPpWrbqDt2t5p5LGx2g58hr+uySLRN3vR4=";
  };

  npmDepsHash = "sha256-Es4Pu3XG9qQiCpYJMIfhKiqCGb4R4Focu/2ol4qRiW8=";

  dontNpmBuild = true;

  meta = {
    homepage = "https://www.getpostman.com";
    description = "Command-line collection runner for Postman";
    mainProgram = "newman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
