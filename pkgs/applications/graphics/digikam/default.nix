{ mkDerivation, lib, fetchFromGitHub, cmake, doxygen, extra-cmake-modules, wrapGAppsHook, fetchpatch

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebkit

, kcalcore
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
, libksane
, liblqr1
, libqtav
, libusb1
, marble
, libGLU_combined
, mysql
, opencv3
, pcre
, threadweaver

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, oxygen
}:

mkDerivation rec {
  name    = "digikam-${version}";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "digikam";
    rev    = "v${version}";
    sha256 = "1bvidg0fn92xvw5brhb34lm7m4iy4jb5xpvnhbgh8vik2m4n41w1";
  };

  nativeBuildInputs = [ cmake doxygen extra-cmake-modules kdoctools wrapGAppsHook ];

  buildInputs = [
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
    libksane
    liblqr1
    libqtav
    libusb1
    libGLU_combined
    opencv3
    pcre

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebkit

    kcalcore
    kconfigwidgets
    kcoreaddons
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    marble
    oxygen
    threadweaver
  ];

  cmakeFlags = [
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
