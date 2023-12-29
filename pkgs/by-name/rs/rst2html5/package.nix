{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "rst2html5";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ejjja/fm6wXTf9YtjCYZsNDB8X5oAtyPoUIsYFDuZfc=";
  };

  buildInputs = with python3Packages; [
    beautifulsoup4
    docutils
    genshi
    pygments
  ];

  meta = with lib;{
    homepage = "https://rst2html5.readthedocs.io/en/latest/";
    description = "Converts ReSTructuredText to (X)HTML5";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
