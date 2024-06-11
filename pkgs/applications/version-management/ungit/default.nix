{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.26";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-HTo0z/y7thUrDm6ofHiUtv1UDuqGN+kpMFLuIvxyxZQ=";
  };

  npmDepsHash = "sha256-f/CtNYoy5ZOgdVTG2ZdBpXOSNUKSG5wCy0eIl4ov80U=";

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
