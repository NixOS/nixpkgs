{ withKDE ? true
, stdenv, fetchurl, gettext, poppler_qt4, qt4
# Qt only (no KDE):
, pkgconfig
# With KDE
, cmake, automoc4, kdelibs
}:

# Warning: You will also need a working pdflatex installation containing (at
# least) auctex and pgf.

assert withKDE -> kdelibs != null;

let
  version = "0.10";

  qtikz = {
    name = "qtikz-${version}";

    conf = ''
      # installation prefix:
      #PREFIX = ""

      # install desktop file here (*nix only):
      DESKTOPDIR = ''$''${PREFIX}/share/applications

      # install mimetype here:
      MIMEDIR = ''$''${PREFIX}/share/mime/packages

      CONFIG -= debug
      CONFIG += release

      # qmake command:
      QMAKECOMMAND = qmake
      # lrelease command:
      LRELEASECOMMAND = lrelease
      # qcollectiongenerator command:
      #QCOLLECTIONGENERATORCOMMAND = qcollectiongenerator

      # TikZ documentation default file path:
      TIKZ_DOCUMENTATION_DEFAULT = ''$''${PREFIX}/share/doc/texmf/pgf/pgfmanual.pdf.gz
    '';

    patchPhase = ''
      echo "$conf" > conf.pri
    '';

    configurePhase = ''
      qmake PREFIX="$out" ./qtikz.pro
    '';

    buildInputs = [ gettext qt4 poppler_qt4 pkgconfig ];
  };

  ktikz = {
    name = "ktikz-${version}";
    buildInputs = [ kdelibs cmake qt4 automoc4 gettext poppler_qt4 ];
  };

  common = {
    inherit version;
    src = fetchurl {
      url = "http://www.hackenberger.at/ktikz/ktikz_${version}.tar.gz";
      sha256 = "19jl49r7dw3vb3hg52man8p2lszh71pvnx7d0xawyyi0x6r8ml9i";
    };

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Editor for the TikZ language";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = [ maintainers.layus ];
    };
  };

in stdenv.mkDerivation (common // (if withKDE then ktikz else qtikz))

