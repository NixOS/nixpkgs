{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.3";
  name = "wikicurses-${version}";

  src = fetchurl {
    url = "http://github.com/ids1024/wikicurses/archive/v${version}.tar.gz";
    sha256 = "1yxgafk1sczg1xi2p6nhrvr3hchp7ydw98n48lp3qzwnryn1kxv8";
  };

  propagatedBuildInputs = with pythonPackages; [ urwid beautifulsoup4 lxml ];

  meta = {
    description = "A simple curses interface for MediaWiki sites such as Wikipedia";
    homepage = "https://github.com/ids1024/wikicurses/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };

}

