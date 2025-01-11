{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "config-visualizer";
  version = "unstable-2022-02-23";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "60f2165f25352c8261f370dc4ceb64a8b422d4ec";
    hash = "sha256-2dnpkec9hN4oAqwu+1WmDJrfeu+JbfqZ6guv3bC4H1c=";
  };

  propagatedBuildInputs = with python3Packages; [
    lxml
    pydot
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/precice/config-visualizer";
    description = "Small python tool for visualizing the preCICE xml configuration";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
    mainProgram = "precice-config-visualizer";
  };
}
