{
  lib,
  buildGo122Module,
  fetchFromGitLab,
}:
let
  version = "1.1";
in
buildGo122Module {
  pname = "invidious-router";
  inherit version;

  src = fetchFromGitLab {
    owner = "gaincoder";
    repo = "invidious-router";
    rev = version;
    hash = "sha256-t8KQqMPkBbVis1odDcSu+H0uvyvoFqCmtWoHqVRxmfc=";
  };

  vendorHash = "sha256-c03vYidm8SkoesRVQZdg/bCp9LIpdTmpXdfwInlHBKk=";

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/gaincoder/invidious-router";
    description = "A Go application that routes requests to different Invidious instances based on their health status and (optional) response time";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sils ];
    mainProgram = "invidious-router";
  };
}
