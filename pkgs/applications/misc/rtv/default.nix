{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  version = "1.25.1";
  pname = "rtv";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0pfsf17g37d2v1xrsbfdbv460vs7m955h6q51z71rhb840r9812p";
  };

  # Tests try to access network
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  checkInputs = [
    coverage
    coveralls
    docopt
    mock
    pylint
    pytest
    vcrpy
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    decorator
    kitchen
    requests
    six
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds wedens ];
  };
}
