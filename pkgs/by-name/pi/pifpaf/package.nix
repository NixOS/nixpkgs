{
  lib,
  python3Packages,
  fetchPypi,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f9nPb483tuvNk82wDtuB6553z18qY/x0tgz1NbVGUWE=";
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
