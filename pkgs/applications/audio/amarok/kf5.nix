{ mkDerivation, fetchgit, lib
, extra-cmake-modules, kdoctools
, qca-qt5, qjson, qtscript, qtwebkit
, kcmutils, kconfig, kdelibs4support, kdnssd, kinit, knewstuff, knotifyconfig, ktexteditor
, phonon, plasma-framework, threadweaver
, curl, ffmpeg, gdk_pixbuf, libaio, libmtp, loudmouth, lzo, lz4, mariadb, pcre, snappy, taglib, taglib_extras
}:

let
  pname = "amarok";
  version = "2.8.91-20170228";

in mkDerivation {
  name = "${pname}-${version}";

  src = fetchgit {
    url    = git://anongit.kde.org/amarok.git;
    # go back to the KDE mirror when kf5 is merged into master
    # url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    rev    = "323e2d5b43245c4c06e0b83385d37ef0d32920cb";
    sha256 = "05w7kl6qfmkjz0y1bhgkkbmsqdll30bkjd6npkzvivrvp7dplmbh";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    qca-qt5 qjson qtscript qtwebkit
    kcmutils kconfig kdelibs4support kdnssd kinit knewstuff knotifyconfig ktexteditor
    phonon plasma-framework threadweaver
    curl ffmpeg gdk_pixbuf libaio libmtp loudmouth lz4 lzo mariadb pcre snappy taglib taglib_extras
  ];
  enableParallelBuilding = true;

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
