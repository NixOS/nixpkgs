{ pkgs }:
with pkgs;

rec {

  libParserUtils = import ./libParserUtils.nix {
    inherit fetchurl pkgconfig stdenv lib;
  };

  libCSS = import ./libCSS.nix {
    inherit fetchurl stdenv lib pkgconfig libParserUtils libwapcaplet;
    inherit (bleedingEdgeRepos) sourceByName;
  };

  libnsbmp = import ./libnsbmp.nix {
    inherit fetchurl stdenv lib;
  };

  libnsgif = import ./libnsgif.nix {
    inherit fetchurl stdenv lib;
  };

  libwapcaplet = import ./libwapcaplet.nix {
    inherit fetchurl stdenv lib;
    inherit (bleedingEdgeRepos) sourceByName;
  };

  libsvgtiny = import ./libsvgtiny.nix {
    inherit fetchurl stdenv lib pkgconfig gperf libxml2;
    inherit (bleedingEdgeRepos) sourceByName;
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

    src = bleedingEdgeRepos.sourceByName "libdom";
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
    inherit fetchurl stdenv lib zlib libpng; 
    inherit (bleedingEdgeRepos) sourceByName;
  };

  browser = import ./netsurf.nix {
    inherit fetchurl stdenv lib pkgconfig
      libnsbmp libnsgif libsvgtiny libwapcaplet hubub libParserUtils
      libpng libxml2 libCSS lcms curl libmng;
    libharu = netsurfHaru;
    inherit (gnome) glib gtk libglade;
    inherit (bleedingEdgeRepos) sourceByName;
  };


}
