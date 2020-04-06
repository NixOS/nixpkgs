{ stdenv, python, fetchpatch }:

with python.pkgs;

buildPythonApplication rec {
  pname = "haxor-news";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b9af8338a0f8b95a8133b66ef106553823813ac171c0aefa3f3f2dbeb4d7f88";
  };

  # allow newer click version
  patches = fetchpatch {
    url = "${meta.homepage}/commit/5b0d3ef1775756ca15b6d83fba1fb751846b5427.patch";
    sha256 = "1551knh2f7yarqzcpip16ijmbx8kzdna8cihxlxx49ww55f5sg67";
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
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
