{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.6.1";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0ywx4h37b25w36vln2ydpw73ysbbkpibp597cghsfn2izlaa0i02";
  };

  propagatedBuildInputs = with pythonPackages; [
    tornado
    requests2
    six
    praw
    kitchen
    python.modules.curses
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
