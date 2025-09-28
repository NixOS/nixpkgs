{
  lib,
  python3Packages,
  fetchPypi,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xXkMj1sP1xXf6Ad/71BFbq8SHz/uHcaSqv6RQN0Ca1o=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    click
    daiquiri
    fixtures
    jinja2
    pbr
    psutil
    xattr
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      requests
      testtools
    ]
    ++ [
      addBinToPathHook
    ];

  pythonImportsCheck = [ "pifpaf" ];

  meta = with lib; {
    description = "Suite of tools and fixtures to manage daemons for testing";
    mainProgram = "pifpaf";
    homepage = "https://github.com/jd/pifpaf";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
