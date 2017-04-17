{ stdenv, fetchurl, cmake, extra-cmake-modules, makeQtWrapper

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebkit

, kconfigwidgets
, kcoreaddons
, kdoctools
, kfilemetadata
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui

, bison
, boost
, eigen
, exiv2
, flex
, jasper
, lcms2
, lensfun
, libgphoto2
, libkipi
, liblqr1
, libusb1
, marble
, mysql
, opencv
, threadweaver

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, oxygen
}:

stdenv.mkDerivation rec {
  name    = "digikam-${version}";
  version = "5.4.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/${name}.tar.xz";
    sha256 = "0dgsgji14l5zvxny36hrfsp889fsfrsbbn9bg57m18404xp903kg";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeQtWrapper ];

  patches = [ ./0001-Disable-fno-operator-names.patch ];

  buildInputs = [
    qtbase
    qtxmlpatterns
    qtsvg
    qtwebkit

    kconfigwidgets
    kcoreaddons
    kdoctools
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    bison
    boost
    eigen
    exiv2
    flex
    jasper
    lcms2
    lensfun
    libgphoto2
    libkipi
    liblqr1
    libusb1
    marble.unwrapped
    mysql
    opencv
    threadweaver

    oxygen
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DLIBUSB_LIBRARIES=${libusb1.out}/lib"
    "-DLIBUSB_INCLUDE_DIR=${libusb1.dev}/include/libusb-1.0"
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
  ];

  fixupPhase = ''
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"

    wrapQtProgram $out/bin/digikam \
      --prefix PATH : "${gnumake}/bin:${hugin}/bin:${enblend-enfuse}/bin"

    wrapQtProgram $out/bin/showfoto
  '';

  meta = {
    description = "Photo Management Program";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.linux;
  };
}
