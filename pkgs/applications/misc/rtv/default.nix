{ stdenv, fetchFromGitHub, pkgs, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.4.2";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "103ahwaaghxpih5bkbzqyqgxqmx6kc859vjla8fy8scg21cijghh";
  };

  propagatedBuildInputs = with pythonPackages; [
    requests
    six
    praw
    kitchen
    python.modules.curses
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
