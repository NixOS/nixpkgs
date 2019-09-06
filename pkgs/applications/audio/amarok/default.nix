{ mkDerivation, fetchgit, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver
, curl, ffmpeg, gdk-pixbuf, libaio, libmtp, loudmouth, lzo, lz4, mysql57, pcre, snappy, taglib, taglib_extras
}:

mkDerivation {
  pname = "amarok";
  version = "2.9.0-20190731";

  src = fetchgit {
    # master has the Qt5 version as of April 2018 but a formal release has not
    # yet been made so change this back to the proper upstream when such a
    # release is out
    url    = git://anongit.kde.org/amarok.git;
    # url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.CZ";
    rev    = "783da6d8e93737f5e41a3bc017906dc1f94bb94f";
    sha256 = "08bypxk5kaay98hbwz9pj3hwgiyk3qmn9qw99bnjkkkw9wzsxiy6";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  propagatedBuildInputs = [
    qca-qt5 qjson qtquickcontrols2 qtscript qtwebengine
    karchive kcmutils kconfig kdnssd kguiaddons kinit kirigami2 knewstuff knotifyconfig ktexteditor kwindowsystem
    phonon plasma-framework threadweaver
    curl fftw ffmpeg gdk-pixbuf libaio libmtp loudmouth lz4 lzo mysql57.server mysql57.server.static
    pcre snappy taglib taglib_extras
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
