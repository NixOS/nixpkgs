{ stdenv, fetchurl, pkgs, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.2.2";
  name = "rtv-${version}";

  src = fetchurl {
    url = "https://github.com/michael-lazar/rtv/archive/v${version}.tar.gz";
    sha256 = "0pisairv28lhqvq8zs0whz3ww8fraj98941kk5idyxadbq0icmk3";
  };

  propagatedBuildInputs = with pythonPackages; [
    requests
    six
    praw
    python.modules.curses
  ];

  meta = {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}


