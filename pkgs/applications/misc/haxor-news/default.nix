{ stdenv, fetchurl, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "haxor-news";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b9af8338a0f8b95a8133b66ef106553823813ac171c0aefa3f3f2dbeb4d7f88";
  };

  propagatedBuildInputs = [
    click
    colorama
    requests
    pygments
    prompt_toolkit
    six
  ];

  doCheck = false;

  checkInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests -v
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/donnemartin/haxor-news;
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
