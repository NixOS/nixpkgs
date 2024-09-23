{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.27";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-UYY8AJWeGAcb83bmr7KX8ocxz8oQqUaXEXwwoVlwvoc=";
  };

  npmDepsHash = "sha256-AE0V+IoO9Yz80y81ayR08us4gyjjvshRVYPq6thpMr8=";

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
    maintainers = [ ];
  };
}
