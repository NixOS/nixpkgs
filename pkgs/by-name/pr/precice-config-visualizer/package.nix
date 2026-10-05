{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "config-visualizer";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "precice";
    repo = "config-visualizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IYQwAaWFSoYBsGMclAk+dDedwZqKsVV+/RLHB1xAahY=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    lxml
    pydot
    typing-extensions
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/precice/config-visualizer";
    description = "Small python tool for visualizing the preCICE xml configuration";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "precice-config-visualizer";
  };
})
