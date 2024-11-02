{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config, wrapQtAppsHook
, poppler, gnuplot
, qmake, qtbase, qttools
}:

# This package only builds ktikz without KDE integration because KDE4 is
# deprecated and upstream does not (yet ?) support KDE5.
# See historical versions of this file for building ktikz with KDE4.

stdenv.mkDerivation rec {
  version = "0.12";
  pname = "qtikz";

  meta = with lib; {
    description = "Editor for the TikZ language";
    mainProgram = "qtikz";
    homepage = "https://github.com/fhackenberger/ktikz";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.layus ];
    longDescription = ''
      You will also need a working *tex installation in your PATH, containing at least `preview` and `pgf`.
    '';
  };

  src = fetchFromGitHub {
    owner = "fhackenberger";
    repo = "ktikz";
    rev = version;
    sha256 = "1s83x8r2yi64wc6ah2iz09dj3qahy0fkxx6cfgpkavjw9x0j0582";
  };

  patches = [
    # Fix version in qtikz.pro
    (fetchpatch {
      url = "https://github.com/fhackenberger/ktikz/commit/972685a406517bb85eb561f2c8e26f029eacd7db.patch";
      sha256 = "13z40rcd4m4n088v7z2ns17lnpn0z3rzp31lsamic3qdcwjwa5k8";
    })
    # Fix missing qt5.15 QPainterPath include
    (fetchpatch {
      url = "https://github.com/fhackenberger/ktikz/commit/ebe4dfb72ac8a137b475ef688b9f7ac3e5c7f242.patch";
      sha256 = "GIgPh+iUBPftHKIpZR3a0FxmLhMLuPUapF/t+bCuqMs=";
    })
  ];

  nativeBuildInputs = [ pkg-config qttools qmake wrapQtAppsHook ];
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";

  buildInputs = [ qtbase poppler ];

  qmakeFlags = [
    "DESKTOP_INSTALL_DIR=${placeholder "out"}/share/applications"
    "MIME_INSTALL_DIR=${placeholder "out"}/share/mime/packages"
    # qcollectiongenerator does no more exist in `qt5.qttools`.
    # It was merged with qhelpgenerator at some point.
    "QCOLLECTIONGENERATORCOMMAND=qhelpgenerator"
  ];

  qtWrapperArgs = [ ''--prefix PATH : "${gnuplot}/bin"'' ];
}
