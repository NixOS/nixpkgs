{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hyperpotamus";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "pmarkert";
    repo = "hyperpotamus";
    rev = "v${version}";
    hash = "sha256-dExkvObz+PNjqAZnigZHs/DCSHq31jDg9pgFmmtPmWk=";
  };

  npmDepsHash = "sha256-cH0VEhs4q13gnFKQmmu8fXjueBu/u7xtySE6HTm+bik=";

  dontNpmBuild = true;

  meta = {
    description = "YAML based HTTP script processing engine";
    homepage = "https://github.com/pmarkert/hyperpotamus";
    license = lib.licenses.mit;
    mainProgram = "hyperpotamus";
    maintainers = with lib.maintainers; [ onny ];
  };
}
