{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "raiseorlaunch";
  version = "2.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L/hu0mYCAxHkp5me96a6HlEY6QsuJDESpTNhlzVRHWs=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonPath = with python3Packages; [ i3ipc ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "raiseorlaunch" ];

  meta = with lib; {
    maintainers = with maintainers; [ winpat ];
    description = "Run-or-raise-application-launcher for i3 window manager";
    mainProgram = "raiseorlaunch";
    homepage = "https://github.com/open-dynaMIX/raiseorlaunch";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
