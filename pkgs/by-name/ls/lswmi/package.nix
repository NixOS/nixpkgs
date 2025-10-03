{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "lswmi";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UREpRA6o4NNcu6cDwvyGEZ7Qu6qTEsbqgksEx+K68HM=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Utility to retrieve information about WMI devices on Linux";
    homepage = "https://github.com/Wer-Wolf/lswmi";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ synalice ];
    mainProgram = "lswmi";
  };
}
