{ stdenv, fetchFromGitHub, pkgs, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.4";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "071p7idprknpra6mrdjjka8lrr80ykag62rhbsaf6zcz1d9p55cp";
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
