{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "rst2html5";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MJmYyF+rAo8vywGizNyIbbCvxDmCYueVoC6pxNDzKuk=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    docutils
    genshi
    pygments
  ];

  # Tests are not shipped as PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "rst2html5" ];

  meta = with lib; {
    description = "Converts ReSTructuredText to (X)HTML5";
    homepage = "https://rst2html5.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rst2html5";
  };
}
