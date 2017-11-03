{ stdenv, fetchFromGitHub, pkgs, pythonPackages }:

with pythonPackages;
buildPythonApplication rec {
  version = "1.19.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "19rnw9cac06ns10vqn2cj0v61ycrj9g1ysa3hncamwxxibmkycp7";
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
    maintainers = with maintainers; [ matthiasbeyer jgeerds wedens ];
  };
}
