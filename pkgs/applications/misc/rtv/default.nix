{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.8.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0vp9yapm6bm4zdhd1ibbirc23ck7smrbsrask7xkrnz7qysxgsd3";
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
