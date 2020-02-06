{ mkDerivation, fetchgit, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver
, curl, ffmpeg, gdk-pixbuf, libaio, libmtp, loudmouth, lzo, lz4, mysql57, pcre, snappy, taglib, taglib_extras
}:

mkDerivation rec {
  pname = "amarok";
  version = "2.9.0-20190824";

  src = fetchgit {
    # master has the Qt5 version as of April 2018 but a formal release has not
    # yet been made so change this back to the proper upstream when such a
    # release is out
    url    = git://anongit.kde.org/amarok.git;
    # url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    rev    = "457fbda25a85a102bfda92aa7137e7ef5e4c8b00";
    sha256 = "1ig2mg8pqany6m2zplkrvldcv4ibxwsypnyv5igm7nz7ax82cd5j";
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
    homepage = "https://amarok.kde.org";
    description = "A powerful music player with an intuitive interface";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
