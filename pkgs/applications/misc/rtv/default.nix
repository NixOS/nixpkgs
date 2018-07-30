{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  version = "1.23.0";
  pname = "rtv";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0i6iqj3ly1bgsfa9403m5190mfl9yk1x4ific3v31wqfja985nsr";
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
    maintainers = with maintainers; [ jgeerds wedens ];
  };
}
