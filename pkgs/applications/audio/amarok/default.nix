{ stdenv, fetchurl, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver, breeze-icons, wrapQtAppsHook
, curl, ffmpeg, gdk-pixbuf, libaio, liblastfm, libmtp, loudmouth, lzo, lz4, mariadb-embedded, pcre, snappy, taglib, taglib_extras
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amarok";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/amarok/${finalAttrs.version}/amarok-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-FKh2eDBfrXagodrKVVpndf+mQuXrvMzs2R9JcJOZLBw=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapQtAppsHook ];

  propagatedBuildInputs = [
    qca-qt5 qjson qtquickcontrols2 qtscript qtwebengine
    karchive kcmutils kconfig kdnssd kguiaddons kinit kirigami2 knewstuff knotifyconfig ktexteditor kwindowsystem
    phonon plasma-framework threadweaver
    curl fftw ffmpeg gdk-pixbuf libaio liblastfm libmtp loudmouth lz4 lzo mariadb-embedded
    pcre snappy taglib taglib_extras breeze-icons
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://amarok.kde.org";
    description = "Powerful music player with an intuitive interface";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
})
