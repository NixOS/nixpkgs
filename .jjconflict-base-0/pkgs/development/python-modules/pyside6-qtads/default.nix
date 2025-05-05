{
  lib,
  buildPythonPackage,
  cmake-build-extension,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  pyside6,
  qt6,
  setuptools,
  setuptools-scm,
  shiboken6,
}:

buildPythonPackage rec {
  pname = "pyside6-qtads";
  version = "4.3.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "pyside6_qtads";
    tag = "v${version}";
    hash = "sha256-02YUeD9PfcaYkvz9JX5FucsbG9Idk7OH24U+RXXEmvo=";
    fetchSubmodules = true;
  };

  # bypass the broken parts of their bespoke python script cmake plugin
  patches = [ ./find-nix-deps.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail @shiboken6@ ${shiboken6} \
      --replace-fail @pyside6@ ${pyside6}

    # can't use pythonRelaxDepsHook because it runs postBuild but the dependency check
    #  happens during build.
    # -Essentials is a smaller version of PySide6, but the name mismatch breaks build
    # _generator is also a virtual package with the same issue
    substituteInPlace pyproject.toml \
      --replace-warn 'PySide6-Essentials' "" \
      --replace-warn 'shiboken6_generator' "" \
      --replace-quiet '"",' "" \
      --replace-quiet '""' ""
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qtquick3d
  ];

  build-system = [
    cmake-build-extension
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyside6
    shiboken6
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  # cmake-build-extension will configure
  dontUseCmakeConfigure = true;

  dontWrapQtApps = true;
  # runtime deps check fails on the pyside6-essentials virtual package
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "PySide6QtAds" ];

  meta = {
    description = "Python bindings to Qt Advanced Docking System for PySide6";
    homepage = "https://github.com/mborgerson/pyside6_qtads";
    changelog = "https://github.com/mborgerson/pyside6_qtads/releases/tag/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
