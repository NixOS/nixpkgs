{ mkDerivation, fetchgit, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver
, curl, ffmpeg_3, gdk-pixbuf, libaio, liblastfm, libmtp, loudmouth, lzo, lz4, mysql57, pcre, snappy, taglib, taglib_extras
}:

mkDerivation rec {
  pname = "amarok-unstable";
  version = "2020-06-12";

  src = fetchgit {
    # master has the Qt5 version as of April 2018 but a formal release has not
    # yet been made so change this back to the proper upstream when such a
    # release is out
    url    = "https://invent.kde.org/multimedia/amarok.git";
    # url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    rev    = "fece39b0e81db310b6a6e08f93d83b0d498cd02b";
    sha256 = "12casnq6w5yp2jlvnr466pjpkn0vriry8jzfq2qkjl564y0vhy9x";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  propagatedBuildInputs = [
    qca-qt5 qjson qtquickcontrols2 qtscript qtwebengine
    karchive kcmutils kconfig kdnssd kguiaddons kinit kirigami2 knewstuff knotifyconfig ktexteditor kwindowsystem
    phonon plasma-framework threadweaver
    curl fftw ffmpeg_3 gdk-pixbuf libaio liblastfm libmtp loudmouth lz4 lzo mysql57.server mysql57.server.static
    pcre snappy taglib taglib_extras
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://amarok.kde.org";
    description = "A powerful music player with an intuitive interface";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
