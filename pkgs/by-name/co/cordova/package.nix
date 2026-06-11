{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cordova";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cordova-cli";
    tag = version;
    hash = "sha256-GJTrFGrUzSQ/Hsphn0zkjFYQkFw5i7ntc8HqIYdOYL4=";
  };

  npmDepsHash = "sha256-y81NdwF+RU20jmCi+Fou3Vc9ivt1x8JOj7biAsuSYDg=";

  dontNpmBuild = true;

  meta = {
    description = "Build native mobile applications using HTML, CSS and JavaScript";
    homepage = "https://github.com/apache/cordova-cli";
    license = lib.licenses.asl20;
    mainProgram = "cordova";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
