{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  version = "1.24.0";
  pname = "rtv";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0vzhnqys8nr6ymsi1mnv092z3i7nwyhgnj4jv6mjifak9j3164fw";
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
