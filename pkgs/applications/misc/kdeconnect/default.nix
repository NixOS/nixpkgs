{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, makeQtWrapper
, kcmutils
, kconfigwidgets
, kdbusaddons
, kiconthemes
, ki18n
, knotifications
, qca-qt5
, libfakekey
, libXtst
}:

stdenv.mkDerivation rec {
  name = "kdeconnect-${version}";
  version = "0.9g";

  src = fetchurl {
    url = http://download.kde.org/unstable/kdeconnect/0.9/src/kdeconnect-kde-0.9g.tar.xz;
    sha256 = "4033754057bbc993b1d4350959afbe1d17a4f1e56dd60c6df6abca5a321ee1b8";
  };

  buildInputs = [
    kcmutils
    kconfigwidgets
    kdbusaddons
    qca-qt5
    ki18n
    kiconthemes
    knotifications
    libfakekey
    libXtst
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    makeQtWrapper
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kdeconnect-cli"
  '';

  meta = {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://community.kde.org/KDEConnect;
  };

}
