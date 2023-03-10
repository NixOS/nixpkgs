{ mkDerivation, fetchurl, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver, breeze-icons
, curl, ffmpeg, gdk-pixbuf, libaio, liblastfm, libmtp, loudmouth, lzo, lz4, mariadb-embedded, pcre, snappy, taglib, taglib_extras
}:

mkDerivation rec {
  pname = "amarok";
  version = "2.9.71";

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "0kz8wixjmy4yxq2gk11ybswryxb6alfymd3bzcar9xinscllhh3a";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

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
    description = "A powerful music player with an intuitive interface";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
