{ mkDerivation, lib, fetchurl, cmake, doxygen, extra-cmake-modules, wrapGAppsHook, fetchpatch

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
, mesa
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
  version = "5.7.0";

  src = fetchurl {
    url = "mirror://kde/stable/digikam/${name}.tar.xz";
    sha256 = "1xah079g47fih8l9qy1ifppfvmq5yms5y1z54nvxdyz8nsszy19n";
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
    mesa
    mysql
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

  enableParallelBuilding = true;

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

  patches = [
    # fix Qt-5.9.3 empty album problem
    (fetchpatch {
      url = "https://cgit.kde.org/digikam.git/patch/?id=855ba5b7d4bc6337234720a72ea824ddd3b32e5b";
      sha256 = "0zk8p182piy6xn9v0mhwawya9ciq596vql1qc3lgnx371a97mmni";
    })
  ];

  patchFlags = "-d core -p1";

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
