{
  lib,
  fetchFromGitHub,
  python312,
  libxcb-cursor,
}:

python312.pkgs.buildPythonApplication rec {
  pname = "angr-management";
  version = "9.2.154";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    tag = "v${version}";
    hash = "sha256-ZaQRXCt6u5FGApiXTToJdIXBnBLv3emo13YG5ip0lJA=";
  };

  pythonRelaxDeps = [
    "angr"
    "binsync"
    "qtawesome"
  ];

  buildInputs = [ libxcb-cursor ];

  build-system = with python312.pkgs; [ setuptools ];

  dependencies =
    with python312.pkgs;
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
      ++ angr.optional-dependencies.angrdb
      ++ requests.optional-dependencies.socks
      ++ thefuzz.optional-dependencies.speedup
    );

  pythonImportsCheck = [ "angrmanagement" ];

  meta = {
    description = "Graphical binary analysis tool powered by the angr binary analysis platform";
    homepage = "https://github.com/angr/angr-management";
    changelog = "https://github.com/angr/angr-management/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      scoder12
    ];
    mainProgram = "angr-management";
  };
}
