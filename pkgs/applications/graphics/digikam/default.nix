{ mkDerivation, lib, fetchFromGitHub, cmake, doxygen, extra-cmake-modules, wrapGAppsHook

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebengine

, akonadi-contacts
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
, ffmpeg
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
, libGL
, libGLU
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
  pname   = "digikam";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "digikam";
    rev    = "v${version}";
    sha256 = "0h0jqfgpanhxfi3r7cgip58ppypqx79z6c5jj7i7f19hp2zziip8";
  };

  nativeBuildInputs = [ cmake doxygen extra-cmake-modules kdoctools wrapGAppsHook ];

  buildInputs = [
    bison
    boost
    eigen
    exiv2
    ffmpeg
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
    libGL
    libGLU
    opencv3
    pcre

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebengine

    akonadi-contacts
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
    "-DENABLE_QWEBENGINE=on"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    gappsWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${qtbase.qtPluginPrefix}/${pname})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = https://www.digikam.org;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
