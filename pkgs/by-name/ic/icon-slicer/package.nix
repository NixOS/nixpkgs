{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gdk-pixbuf,
  popt,
}:
stdenv.mkDerivation rec {
  pname = "icon-slicer";
  version = "0.3";

  src = fetchurl {
    url = "https://freedesktop.org/software/icon-slicer/releases/icon-slicer-${version}.tar.gz";
    sha256 = "0kdnc08k2rs8llfg7xgvnrsk60x59pv5fqz6kn2ifnn2s1nj3w05";
  };

  patches = [
    # Fixes hotspot `y` coordinate. The `x` coordinate is used on the y-axis.
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/hotspotfix.patch?h=icon-slicer";
      sha256 = "1l1dc1x5p4hys02arkmq3x6b1xdi510969d25g928zr4gf4an03h";
    })
  ];

  nativeBuildInputs = [
    popt
    pkg-config
  ];
  buildInputs = [ gdk-pixbuf ];

  meta = with lib; {
    description = "Utility for generating icon themes and libXcursor cursor themes";
    homepage = "https://www.freedesktop.org/wiki/Software/icon-slicer/";
    license = licenses.mit;
    maintainers = with maintainers; [ zaninime ];
    platforms = platforms.linux;
    mainProgram = "icon-slicer";
  };
}
