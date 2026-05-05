{
  lib,
  fetchFromGitHub,
  python312Packages,
  libxcb-cursor,
}:

python312Packages.buildPythonApplication (finalAttrs: {
  pname = "angr-management";
  version = "9.2.212";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-management";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u+VVvWDipjDyOyWMznZrm0lvf+2eB4rWGpABE+YwZP0=";
  };

  pythonRelaxDeps = [
    "angr"
    "binsync"
    "qtawesome"
  ];

  buildInputs = [ libxcb-cursor ];

  build-system = with python312Packages; [ setuptools ];

  dependencies =
    with python312Packages;
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
    changelog = "https://github.com/angr/angr-management/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      scoder12
    ];
    mainProgram = "angr-management";
  };
})
