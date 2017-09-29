{ stdenv, fetchFromGitHub, pkgs, pythonPackages }:

with pythonPackages;
buildPythonApplication rec {
  version = "1.18.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "00d2s29sp68hw8ljjmzn5dc5ly2s3c7qf0azwizgd3b40zlfgzcg";
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
