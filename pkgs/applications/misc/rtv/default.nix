{ stdenv, fetchFromGitHub, pkgs, pythonPackages }:

with pythonPackages;
buildPythonApplication rec {
  version = "1.23.0";
  name = "rtv-${version}";

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

  buildInputs = [
    coverage
    coveralls
    docopt
    mock
    pylint
    pytest
    vcrpy
  ];

  propagatedBuildInputs = [
    backports_functools_lru_cache
    beautifulsoup4
    configparser
    contextlib2
    decorator
    kitchen
    mailcap-fix
    mccabe
    requests
    six
    tornado
    pyyaml
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds wedens ];
  };
}
