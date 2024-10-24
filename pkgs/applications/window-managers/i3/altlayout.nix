{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3altlayout";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zdp5zPeT3Cg/7uUG9WIZEFP1T11W6orQ9fEPljCk1H8=";
  };

  build-system  = with python3Packages; [ setuptools ];

  pythonPath = with python3Packages; [
    i3ipc
    docopt
  ];

  doCheck = false;

  pythonImportsCheck = [ "i3altlayout" ];

  meta = with lib; {
    description = "Helps you handle more efficiently your screen real estate in i3wm by auto-splitting windows on their longest side";
    homepage = "https://github.com/deadc0de6/i3altlayout";
    changelog = "https://github.com/deadc0de6/i3altlayout/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ magnetophon ];
    mainProgram = "i3altlayout";
    platforms = platforms.linux;
  };
}
