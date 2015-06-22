{ stdenv, fetchurl, pkgs, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.4";
  name = "rtv-${version}";

  src = fetchurl {
    url = "https://github.com/michael-lazar/rtv/archive/v${version}.tar.gz";
    sha256 = "0qi45was70p3z15pnh25hkbliya440jldlzmpasqvbdy9zdgpv0w";
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
