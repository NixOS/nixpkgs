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
  version = "1.0";

  src = fetchurl {
    url = http://download.kde.org/stable/kdeconnect/1.0/src/kdeconnect-kde-1.0.tar.xz;
    sha256 = "0pd8qw0w6akc7yzmsr0sjkfj3nw6rgm5xvq41g61ak8pp05syzr0";
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
