{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "resumed";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "rbardini";
    repo = "resumed";
    rev = "v${version}";
    hash = "sha256-zV+3HZ89bQoSHdZcYkdeqYJI0UnEZFAG3U/ZC9iHcvE=";
  };

  npmDepsHash = "sha256-zm4FU/xCFJmsZt4uib+pSiCP023p4mGGiODq4QW0zV0=";

  meta = {
    description = "Lightweight JSON Resume builder, no-frills alternative to resume-cli";
    homepage = "https://github.com/rbardini/resumed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "resumed";
  };
}
