{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub
}: mkYarnPackage rec {
  pname = "auto-changelog";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "cookpete";
    repo = "auto-changelog";
    rev = "v${version}";
    hash = "sha256-qgJ/TVyViMhISt/EfCWV7XWQLXKTeZalGHFG905Ma5I=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-rP/Xt0txwfEUmGZ0CyHXSEG9zSMtv8wr5M2Na+6PbyQ=";
  };

  meta = {
    description = "Command line tool for generating a changelog from git tags and commit history";
    homepage = "https://github.com/cookpete/auto-changelog";
    changelog = "https://github.com/cookpete/auto-changelog/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "auto-changelog";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
