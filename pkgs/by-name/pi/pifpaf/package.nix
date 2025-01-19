{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L039ZAFnYLCU52h1SczJU0T7+1gufxQlVzQr1EPCqc8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    daiquiri
    fixtures
    jinja2
    pbr
    psutil
    xattr
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = with python3.pkgs; [
    requests
    testtools
  ];

  pythonImportsCheck = [ "pifpaf" ];

  meta = {
    description = "Suite of tools and fixtures to manage daemons for testing";
    mainProgram = "pifpaf";
    homepage = "https://github.com/jd/pifpaf";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
