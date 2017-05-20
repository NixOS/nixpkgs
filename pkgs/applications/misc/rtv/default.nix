{ stdenv, fetchFromGitHub, pkgs, pythonPackages }:

with pythonPackages;
buildPythonApplication rec {
  version = "1.15.1";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "037dhds1prxj7vsq15dr46wk3pfk3ixr0d60m3h796b6nbc1spya";
  };

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
