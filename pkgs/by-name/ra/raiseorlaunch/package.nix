{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "raiseorlaunch";
  version = "2.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-L/hu0mYCAxHkp5me96a6HlEY6QsuJDESpTNhlzVRHWs=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonPath = with python3Packages; [ i3ipc ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "raiseorlaunch" ];

  meta = {
    maintainers = with lib.maintainers; [ winpat ];
    description = "Run-or-raise-application-launcher for i3 window manager";
    mainProgram = "raiseorlaunch";
    homepage = "https://github.com/open-dynaMIX/raiseorlaunch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
