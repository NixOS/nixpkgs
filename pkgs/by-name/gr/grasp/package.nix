{
  lib,
  fetchFromGitHub,
  python3,
}:
let
  inherit (python3.pkgs)
    buildPythonApplication
    hatchling
    hatch-vcs
    toxCheckHook
    ;
in
buildPythonApplication rec {
  pname = "grasp-packaend";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = "grasp";
    tag = "v${version}";
    hash = "sha256-4eHY58ulvLGkKHfEishRlWPI52juxWP2zzUDwRmTM/k=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    hatch-vcs
  ];

  nativeCheckInputs = [
    toxCheckHook
  ];

  meta = {
    description = "Backend for grasp browser extension";
    mainProgram = "grasp_backend";
    homepage = "https://github.com/karlicoss/grasp/";
    license = lib.licenses.mit;
  };
}
