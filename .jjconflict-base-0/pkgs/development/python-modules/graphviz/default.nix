{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  substituteAll,
  graphviz-nox,
  xdg-utils,
  makeFontsConf,
  freefont_ttf,
  setuptools,
  mock,
  pytest_7,
  pytest-mock,
  python,
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.20.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = "refs/tags/${version}";
    hash = "sha256-IqjqcBEL4BK/VfRjdxJ9t/DkG8OMAoXJxbW5JXpALuw=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      graphviz = graphviz-nox;
      xdgutils = xdg-utils;
    })
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ freefont_ttf ]; };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytest_7
    pytest-mock
  ];

  checkPhase = ''
    runHook preCheck

    HOME=$TMPDIR ${python.interpreter} run-tests.py

    runHook postCheck
  '';

  # Too many failures due to attempting to connect to com.apple.fonts daemon
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    changelog = "https://github.com/xflr6/graphviz/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
