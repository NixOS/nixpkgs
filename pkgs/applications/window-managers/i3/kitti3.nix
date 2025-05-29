{
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  i3ipc,
  lib,
}:

buildPythonApplication rec {
  pname = "kitti3";
  version = "unstable-2021-09-11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LandingEllipse";
    repo = pname;
    rev = "f9f94c8b9f8b61a9d085206ada470cfe755a2a92";
    hash = "sha256-bcIzbDpIe2GKS9EcVqpjwz0IG2ixNMn06OIQpZ7PeH0=";
  };

  patches = [
    # Fixes `build-system` not being specified in `pyproject.toml`
    # https://github.com/LandingEllipse/kitti3/pull/25
    ./kitti3-fix-build-system.patch
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    i3ipc
  ];

  meta = with lib; {
    homepage = "https://github.com/LandingEllipse/kitti3";
    description = "Kitty drop-down service for sway & i3wm";
    mainProgram = "kitti3";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
