{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
}:
mkYarnPackage rec {
  pname = "automerge-repo-sync-server";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "automerge";
    repo = "automerge-repo-sync-server";
    rev = "v${version}";
    hash = "sha256-41aWP0vzAQrppalA8Kw+zBD2ERgQI0mQNnHtnGmAMEU=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-IHIxBnJOLI97vPxcbUdrdXfK/SJBYNZcndME7AzOShc=";
  };

  doDist = false;

  meta = with lib; {
    description = "A very simple automerge-repo synchronization server.";
    homepage = "https://github.com/automerge/automerge-repo-sync-server";
    changelog = "https://github.com/automerge/automerge-repo-sync-server/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ xlambein ];
    mainProgram = "automerge-repo-sync-server";
    platforms = platforms.all;
  };
}
