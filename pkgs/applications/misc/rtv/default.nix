{ stdenv, fetchFromGitHub, pkgs, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.4.1";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0jh7gcj7fdclfjcyh6kzvz25p5ivw5jn5b1fy863223f7fm4j7fz";
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
