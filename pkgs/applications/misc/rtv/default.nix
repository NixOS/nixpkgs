{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.15.1";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "037dhds1prxj7vsq15dr46wk3pfk3ixr0d60m3h796b6nbc1spya";
  };

  propagatedBuildInputs = with pythonPackages; [
    beautifulsoup4
    mailcap-fix
    tornado
    requests2
    six
    praw
    kitchen
    praw
    vcrpy
    pylint
    coverage
    pytest
    coveralls
    contextlib2
    backports_functools_lru_cache
    pyyaml
    docopt
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds wedens ];
  };
}
