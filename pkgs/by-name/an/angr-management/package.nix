{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "angr-management";
  version = "9.2.147";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    tag = "v${version}";
    hash = "sha256-WPnrLgYae8rRwdhciGrc+z+OjYtkGFslODmBZx+3KPU=";
  };

  pythonRelaxDeps = [ "binsync" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    (
      [
        # requirements from setup.cfg
        angr
        bidict
        binsync
        ipython
        pyqodeng-angr
        pyside6
        pyside6-qtads
        qtawesome
        qtpy
        requests
        rpyc
        thefuzz
        tomlkit
        # requirements from setup.cfg -- vendorized qtconsole package
        ipykernel
        jupyter-client
        jupyter-core
        packaging
        pygments
        pyzmq
        traitlets
      ]
      ++ angr.optional-dependencies.AngrDB
      ++ requests.optional-dependencies.socks
      ++ thefuzz.optional-dependencies.speedup
    );

  pythonImportsCheck = [ "angrmanagement" ];

  meta = {
    description = "The official angr GUI";
    homepage = "https://github.com/angr/angr-management";
    changelog = "https://github.com/angr/angr-management/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ scoder12 ];
    mainProgram = "angr-management";
  };
}
