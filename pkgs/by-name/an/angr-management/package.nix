{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "angr-management";
  version = "9.2.137";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    rev = "v${version}";
    hash = "sha256-2ZKCTgQUcCSmg1/tm8n+3IfDw6Eey4reYgyWYlc7+4w=";
  };

  build-system = with python3.pkgs; [ setuptools ];

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
