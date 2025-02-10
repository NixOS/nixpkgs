{
  lib,
  python3Packages,
  fetchPypi,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L039ZAFnYLCU52h1SczJU0T7+1gufxQlVzQr1EPCqc8=";
  };

  propagatedBuildInputs = with python3Packages; [
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
