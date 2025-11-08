{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "bodyclose";
  version = "0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "timakin";
    repo = "bodyclose";
    rev = "1db5c5ca4d6719fe28430df1ae8d337ee2ac09c7";
    hash = "sha256-s5bWvpV6gHGEsuiNXJl2ZuyDaffD82/rCbusov3zsyw=";
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
