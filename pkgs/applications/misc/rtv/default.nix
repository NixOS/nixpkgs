{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  version = "1.26.0";
  pname = "rtv";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0smwlhc4sj92365pl7yy6a821xddmh9px43nbd0kdd2z9xrndyx1";
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
    maintainers = with maintainers; [ matthiasbeyer wedens ];
  };
}
