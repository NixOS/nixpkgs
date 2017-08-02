{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.3";
  name = "wikicurses-${version}";

  src = fetchurl {
    url = "http://github.com/ids1024/wikicurses/archive/v${version}.tar.gz";
    sha256 = "1yxgafk1sczg1xi2p6nhrvr3hchp7ydw98n48lp3qzwnryn1kxv8";
  };

  patches = [
    # This is necessary to build without a config file.
    # It can be safely removed after updating to wikicurses to 1.4
    # or when commit 4b944ac339312b642c6dc5d6b5a2f7be7503218f is included
    (fetchurl {
      url = "https://github.com/ids1024/wikicurses/commit/4b944ac339312b642c6dc5d6b5a2f7be7503218f.patch";
      sha256 = "0ii4b0c4hb1zdhcpp4ij908mfy5b8khpm1l7xr7lp314lfhsg9as";
    })
  ];

  propagatedBuildInputs = with pythonPackages; [ urwid beautifulsoup4 lxml ];

  meta = {
    description = "A simple curses interface for MediaWiki sites such as Wikipedia";
    homepage = https://github.com/ids1024/wikicurses/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };

}

