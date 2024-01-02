{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.24";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-4hDg153CVZidmnIGUwxfzL45Yt+GlMyepfMLJbcjdqo=";
  };

  npmDepsHash = "sha256-Z/vPqJ70NqjABKKa8r24t0sWoPYRVwxH02BNr1yCVNQ=";

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
