{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "i3a";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1xK2zau675gTWdEcOicBX3CxfenNnukuVXVA6FZpI+E=";
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
})
