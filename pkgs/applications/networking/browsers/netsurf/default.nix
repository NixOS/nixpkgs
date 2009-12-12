{ pkgs }:
with pkgs;

rec {

  libParserUtils = import ./libParserUtils.nix {
    inherit fetchurl pkgconfig stdenv lib;
  };

  libCSS = import ./libCSS.nix {
    inherit fetchurl sourceFromHead stdenv lib pkgconfig libParserUtils
      libwapcaplet;
  };

  libnsbmp = import ./libnsbmp.nix {
    inherit fetchurl stdenv lib;
  };

  libnsgif = import ./libnsgif.nix {
    inherit fetchurl stdenv lib;
  };

  libwapcaplet = import ./libwapcaplet.nix {
    inherit fetchurl sourceFromHead stdenv lib;
  };

  libsvgtiny = import ./libsvgtiny.nix {
    inherit fetchurl sourceFromHead stdenv lib pkgconfig gperf libxml2;
  };

  hubub = stdenv.mkDerivation {
    name = "Hubbub-0.0.1";

    src = fetchurl {
      url = http://www.netsurf-browser.org/projects/releases/hubbub-0.0.1-src.tar.gz;
      sha256 = "1pwcnxp3h5ysnr3nxhnwghaabri5zjaibrcarsrrnhkn2gvvv81v";
    };

    installPhase = "make PREFIX=$out install";
    buildInputs = [pkgconfig libParserUtils];

    meta = { 
      description = "HTML5 compliant parsing library, written in C";
      homepage = http://www.netsurf-browser.org/projects/hubbub/;
      license = "MIT";
      maintainers = [lib.maintainers.marcweber];
      platforms = lib.platforms.linux;
    };
  };

  /*
  # unfinished - experimental
  libdom = stdenv.mkDerivation {
    name = "libdom-devel";

    # REGION AUTO UPDATE:     { name="libdom"; type = "svn"; url = "svn://svn.netsurf-browser.org/trunk/dom"; groups = "netsurf_group"; }
    src= sourceFromHead "libdom-9721.tar.gz"
                 (fetchurl { url = "http://mawercer.de/~nix/repos/libdom-9721.tar.gz"; sha256 = "ca4b94a8dd32036787331a14133c36a49daded40bdb4c04edc3eab99e2193abc"; });
    # END
    installPhase = "make PREFIX=$out install";
    buildInputs = [pkgconfig];

    meta = { 
      description = "implementation of the W3C DOM, written in C";
      homepage = http://www.netsurf-browser.org/projects/hubbub/;
      license = "MIT";
      maintainers = [lib.maintainers.marcweber];
      platforms = lib.platforms.linux;
    };
  };
  */

  netsurfHaru = import ./haru.nix {
    inherit fetchurl sourceFromHead stdenv lib zlib libpng; 
  };

  browser = import ./netsurf.nix {
    inherit fetchurl sourceFromHead stdenv lib pkgconfig
      libnsbmp libnsgif libsvgtiny libwapcaplet hubub libParserUtils
      libpng libxml2 libCSS lcms curl libmng;
    libharu = netsurfHaru;
    inherit (gnome) glib gtk libglade;
  };


}
