{ stdenv, fetchFromGitHub, fetchurl
, pkgconfig, makeWrapper
, poppler, qt5, gnuplot
}:


# This package only builds ktikz without KDE integration because KDE4 is
# deprecated and upstream does not (yet ?) support KDE5.
# See historical versions of this file for building ktikz with KDE4.

stdenv.mkDerivation rec {
  version = "0.12";
  pname = "qtikz";

  meta = with stdenv.lib; {
    description = "Editor for the TikZ language";
    homepage = "https://github.com/fhackenberger/ktikz";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.layus ];
    long_description = ''
      You will also need a working *tex installation in your PATH, containing at least `preview` and `pgf`.
    '';
  };

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

  QT_PLUGIN_PATH = "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}";

  nativeBuildInputs = [ pkgconfig qt5.qttools qt5.qmake makeWrapper ];
  buildInputs = [ qt5.qtbase poppler ];
  enableParallelBuilding = true;

  qmakeFlags = [
    "DESKTOP_INSTALL_DIR=${placeholder "out"}/share/applications"
    "MIME_INSTALL_DIR=${placeholder "out"}/share/mime/packages"
    # qcollectiongenerator does no more exist in `qt5.qttools`.
    # It was merged with qhelpgenerator at some point.
    "QCOLLECTIONGENERATORCOMMAND=qhelpgenerator"
  ];

  postFixup = ''
    wrapProgram "$out/bin/qtikz" \
      --prefix QT_PLUGIN_PATH : "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}" \
      --prefix PATH : "${gnuplot}/bin"
  '';
}
