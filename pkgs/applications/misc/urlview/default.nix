{ stdenv, fetchurl, ncurses, automake111x, autoreconfHook }:

stdenv.mkDerivation rec {
  version    = "0.9";
  patchLevel = "19";

  name = "urlview-${version}-${patchLevel}";

  urlBase = "mirror://debian/pool/main/u/urlview/";

  src = fetchurl {
    url = urlBase + "urlview_${version}.orig.tar.gz";
    sha256 = "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42";
  };

  buildInputs = [ ncurses automake111x autoreconfHook ];

  preAutoreconf = ''
    touch NEWS
  '';

  preConfigure = ''
    mkdir -p $out/share/man/man1
  '';

  debianPatches = fetchurl {
    url = urlBase + "urlview_${version}-${patchLevel}.diff.gz";
    sha256 = "056883c17756f849fb9235596d274fbc5bc0d944fcc072bdbb13d1e828301585";
  };

  patches = debianPatches;

  meta = {
    description = "Extract URLs from text";
    homepage = http://packages.qa.debian.org/u/urlview.html;
    licencse = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
