{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3a";
  version = "2.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b1bB7Gto4aL1rbQXIelBVhutjIvZY+K+Y66BGN7OcCs=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  dependencies = [ python3Packages.i3ipc ];

  doCheck = false;

  pythonImportsCheck = [ "i3a" ];

  meta = with lib; {
    changelog = "https://git.goral.net.pl/i3a.git/log/";
    description = "Set of scripts used for automation of i3 and sway window manager layouts";
    homepage = "https://git.goral.net.pl/i3a.git/about";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ moni ];
  };
}
