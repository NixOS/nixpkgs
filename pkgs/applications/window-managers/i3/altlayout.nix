{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3altlayout";
  version = "1.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Uj+Y+eaDYmYYlZmmavk8qe/1FXJm2ekkteTFMnq2dWw=";
  };

  pythonRemoveDeps = [ "enum-compat" ];

  pythonPath = with python3Packages; [
    i3ipc
    docopt
  ];

  doCheck = false;

  pythonImportsCheck = [ "i3altlayout" ];

  meta = {
    maintainers = with lib.maintainers; [ magnetophon ];
    description = "Helps you handle more efficiently your screen real estate in i3wm by auto-splitting windows on their longest side";
    mainProgram = "i3altlayout";
    homepage = "https://github.com/deadc0de6/i3altlayout";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
