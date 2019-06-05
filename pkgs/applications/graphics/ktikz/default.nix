{ stdenv, fetchFromGitHub, fetchurl
, gettext, poppler, qt5 , pkgconfig }:

# Warning: You will also need a working pdflatex installation containing
# at least auctex and pgf.

# This package only builds ktikz without KDE integration because KDE4 is
# deprecated and upstream does not (yet ?) support KDE5.
# See historical versions of this file for building ktikz with KDE4.

stdenv.mkDerivation rec {
  version = "0.12";
  name = "qtikz-${version}";

  src = fetchFromGitHub {
    owner = "fhackenberger";
    repo = "ktikz";
    rev = version;
    sha256 = "1s83x8r2yi64wc6ah2iz09dj3qahy0fkxx6cfgpkavjw9x0j0582";
  };

  patches = [ (fetchurl {
    url = "https://github.com/fhackenberger/ktikz/commit/972685a406517bb85eb561f2c8e26f029eacd7db.patch";
    sha256 = "16jwsl18marfw5m888vwxdd1h7cqa37rkfqgirzdliacb1cr4f58";
  })];

  meta = with stdenv.lib; {
    description = "Editor for the TikZ language";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.layus ];
  };

  conf = ''
    # installation prefix:
    PREFIX = @out@

    # install desktop file here (*nix only):
    DESKTOP_INSTALL_DIR = @out@/share/applications

    # install mimetype here:
    MIME_INSTALL_DIR = @out@/share/mime/packages

    # install doc here:
    MAN_INSTALL_DIR = @out@/share/man

    CONFIG -= debug
    CONFIG += release

    # qmake command:
    QMAKECOMMAND = qmake
    # lrelease command:
    LRELEASECOMMAND = lrelease
    # qcollectiongenerator command:
    QCOLLECTIONGENERATORCOMMAND = qhelpgenerator

    # TikZ documentation default file path:
    TIKZ_DOCUMENTATION_DEFAULT = @out@/share/doc/texmf/pgf/pgfmanual.pdf.gz
  '';

  # 1. Configuration is done by overwriting qtikzconfig.pri
  postPatch = ''
    echo "$conf" | sed "s!@out@!$out!g" > qmake/qtikzconfig.pri
  '';

  configurePhase = ''
      qmake PREFIX="$out" ./qtikz.pro
  '';

  nativeBuildInputs = [ pkgconfig qt5.qttools ];
  buildInputs = [ gettext qt5.full poppler ];

  enableParallelBuilding = true;
}
