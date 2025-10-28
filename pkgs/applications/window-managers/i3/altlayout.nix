{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3altlayout";
  version = "0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h0phf3s6ljffxw0bs73k041wildaz01h37iv5mxhami41wrh4qf";
  };

  pythonRemoveDeps = [ "enum-compat" ];

  pythonPath = with python3Packages; [
    i3ipc
    docopt
  ];

  doCheck = false;

  pythonImportsCheck = [ "i3altlayout" ];

  meta = with lib; {
    maintainers = with maintainers; [ magnetophon ];
    description = "Helps you handle more efficiently your screen real estate in i3wm by auto-splitting windows on their longest side";
    mainProgram = "i3altlayout";
    homepage = "https://github.com/deadc0de6/i3altlayout";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
