{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  version = "1.27.0";
  pname = "rtv";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "1hw7xy2kjxq7y3wcibcz4l7zj8icvigialqr17l362xry0y17y5j";
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
    homepage = "https://github.com/michael-lazar/rtv";
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer wedens ];
  };
}
