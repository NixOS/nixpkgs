{
  lib,
  # Build fails with Go 1.25, with the following error:
  # 'vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go:64:9: invalid array length -delta * delta (constant -256 of type int64)'
  # Wait for upstream to update their vendored dependencies before unpinning.
  buildGo124Module,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGo124Module {
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

  meta = {
    description = "Golang linter to check whether HTTP response body is closed and a re-use of TCP connection is not blocked";
    mainProgram = "bodyclose";
    homepage = "https://github.com/timakin/bodyclose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ meain ];
  };
}
