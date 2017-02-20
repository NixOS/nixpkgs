{ stdenv, fetchFromGitHub, gettext, poppler_qt5, qt5 , pkgconfig }:

# Warning: You will also need a working pdflatex installation containing
# at least auctex and pgf.

# This package only builds ktikz without KDE integration because KDE4 is
# deprecated and upstream does not (yet ?) support KDE5.
# See historical versions of this file for building ktikz with KDE4.

stdenv.mkDerivation rec {
  version = "unstable-20161122";
  name = "qtikz-${version}";

  src = fetchFromGitHub {
    owner = "fhackenberger";
    repo = "ktikz";
    rev = "be66c8b1ff7e6b791b65af65e83c4926f307cf5a";
    sha256 = "15jx53sjlnky4yg3ry1i1c29g28v1jbbvhbz66h7a49pfxa40fj3";
  };

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
    #QCOLLECTIONGENERATORCOMMAND = qcollectiongenerator

    # TikZ documentation default file path:
    TIKZ_DOCUMENTATION_DEFAULT = @out@/share/doc/texmf/pgf/pgfmanual.pdf.gz
  '';

  # 1. Configuration is done by overwriting qtikzconfig.pri
  # 2. Recent Qt removed QString::fromAscii in favor of QString::fromLatin1
  patchPhase = ''
    echo "$conf" | sed "s!@out@!$out!g" > qmake/qtikzconfig.pri
    find -name "*.cpp" -exec sed -i s/fromAscii/fromLatin1/g "{}" \;
  '';

  configurePhase = ''
      qmake PREFIX="$out" ./qtikz.pro
  '';

  buildInputs = [ gettext qt5.full poppler_qt5 pkgconfig ];

  enableParallelBuilding = true;
}

