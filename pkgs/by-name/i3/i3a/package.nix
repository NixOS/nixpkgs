{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3a";
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BcGAFFq3UEj4o7nNQ9aStueKmeDNIqSIqkYWhs2Tnqg=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.hatchling
  ];

  dependencies = [ python3Packages.i3ipc ];

  doCheck = false;

  pythonImportsCheck = [ "i3a" ];

  meta = {
    changelog = "https://git.goral.net.pl/i3a.git/log/";
    description = "Set of scripts used for automation of i3 and sway window manager layouts";
    homepage = "https://git.goral.net.pl/i3a.git/about";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      moni
      teohz
    ];
    broken = python3Packages.python.version < "3.11";
  };
}
