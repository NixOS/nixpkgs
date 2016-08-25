{stdenv, fetchurl, qwt, gsl, qwtPlot3D, muparser, zlib, qt4, qmake4Hook, # python2Packages
}:

stdenv.mkDerivation rec {
  version = "1.14";
  name = "scidavis-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/scidavis/SciDAVis/${version}/scidavis-${version}.tar.gz";
    sha256 = "0904dfz0ijgqvx216wy7qic2hhnm0inkmwi9484d1517sb0bdz55";
  };

#  qmakeFlags = "CONFIG+=python";

  installFlags = "INSTALL_ROOT=$(out)";

  postInstall = "mv $out/usr/* $out";

  buildInputs = [
     qwt gsl muparser qt4 zlib qmake4Hook qwtPlot3D
 #    python2Packages.python python2Packages.sip python2Packages.pyqt4 #Support for python
  ];

  meta = with stdenv.lib; {
    homepage = http://scidavis.sourceforge.net/;
    description = "A free application for Scientific Data Analysis and Visualization";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
