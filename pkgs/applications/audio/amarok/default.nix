{ mkDerivation, fetchgit, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtquickcontrols2, qtscript, qtwebengine
, karchive, kcmutils, kconfig, kdnssd, kguiaddons, kinit, kirigami2, knewstuff, knotifyconfig, ktexteditor, kwindowsystem
, fftw, phonon, plasma-framework, threadweaver
, curl, ffmpeg, gdk_pixbuf, libaio, libmtp, loudmouth, lzo, lz4, mysql57, pcre, snappy, taglib, taglib_extras
}:

let
  pname = "amarok";
  version = "2.9.0-20180618";

in mkDerivation {
  name = "${pname}-${version}";

  src = fetchgit {
    # master has the Qt5 version as of April 2018 but a formal release has not
    # yet been made so change this back to the proper upstream when such a
    # release is out
    url    = git://anongit.kde.org/amarok.git;
    # url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    rev    = "5d43efa454b6a6c9c833a6f3d7f8ff3cae738c96";
    sha256 = "0fyrbgldg4wbb2darm4aav5fpzbacxzfjrdqwkhv9xr13j7zsvm3";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  propagatedBuildInputs = [
    qca-qt5 qjson qtquickcontrols2 qtscript qtwebengine
    karchive kcmutils kconfig kdnssd kguiaddons kinit kirigami2 knewstuff knotifyconfig ktexteditor kwindowsystem
    phonon plasma-framework threadweaver
    curl fftw ffmpeg gdk_pixbuf libaio libmtp loudmouth lz4 lzo mysql57.server mysql57.server.static
    pcre snappy taglib taglib_extras
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
