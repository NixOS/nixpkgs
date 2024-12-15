{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "bodyclose";
  version = "0-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "timakin";
    repo = "bodyclose";
    rev = "adbc21e6bf369ca6d936dbb140733f34867639bd";
    hash = "sha256-GNZNzXEZnIxep5BS1sBZsMl876FwwIkOBwHAMk/73fo=";
  };

  vendorHash = "sha256-8grdJuV8aSETsJr2VazC/3ctfnGh3UgjOWD4/xf3uC8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Golang linter to check whether HTTP response body is closed and a re-use of TCP connection is not blocked";
    mainProgram = "bodyclose";
    homepage = "https://github.com/timakin/bodyclose";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
