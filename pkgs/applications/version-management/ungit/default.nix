{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.25";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-mVBE8HW5dhi00BbVX00rgvc4JtyrTsbina18EzSUcuM=";
  };

  npmDepsHash = "sha256-DftAovQPKi4hLeqAGCVN8u/9eC4mkTxTJ2WxxOHbkgM=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  meta = {
    changelog = "https://github.com/FredrikNoren/ungit/blob/${src.rev}/CHANGELOG.md";
    description = "Git made easy";
    homepage = "https://github.com/FredrikNoren/ungit";
    license = lib.licenses.mit;
    mainProgram = "ungit";
    maintainers = with lib.maintainers; [ ];
  };
}
