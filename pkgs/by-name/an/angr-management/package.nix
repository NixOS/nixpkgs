{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "angr-management";
  version = "9.2.130";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    rev = "v${version}";
    hash = "sha256-sT9Ii9+2Iol1RrmMn7aDo+jWSJ8WUuJb0FaSmo3KLgc=";
  };

  patches = [ ./relax-deps.patch ];

  build-system = [ python3.pkgs.setuptools ];

  dependencies =
    with python3.pkgs;
    (
      [
        # requirements from setup.cfg
        pyside6
        pyside6-qtads
        qtawesome
        qtpy
        angr
        bidict
        ipython
        pyqodeng
        requests
        tomlkit
        thefuzz
        binsync
        rpyc
        # requirements from setup.cfg -- vendorized qtconsole package
        traitlets
        jupyter-core
        jupyter-client
        pygments
        ipykernel
        pyzmq
        packaging
      ]
      ++ angr.optional-dependencies.AngrDB
      ++ requests.optional-dependencies.socks
    );

  pythonImportsCheck = [ "angrmanagement" ];

  meta = {
    description = "The official angr GUI";
    homepage = "https://github.com/angr/angr-management";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
    mainProgram = "angr-management";
  };
}
