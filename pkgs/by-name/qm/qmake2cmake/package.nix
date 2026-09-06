{
  lib,
  python3Packages,
  fetchgit,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonPackage {
  pname = "qmake2cmake";
  version = "1.0.8";
  pyproject = true;

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    # v1.0.8 is untagged
    rev = "2ae9ac3a5a657f58d7eea0824ead217e495d048b";
    hash = "sha256-LLP/sdFNsBYrz9gAh76QymtK71T+ZyknTGJiHGJnanU=";
  };

  patches = [
    ./fix-locations.patch
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.packaging
    python3Packages.platformdirs
    python3Packages.portalocker
    python3Packages.pyparsing
    python3Packages.sympy
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Tool to convert qmake .pro files to CMakeLists.txt";
    homepage = "https://wiki.qt.io/Qmake2cmake";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
