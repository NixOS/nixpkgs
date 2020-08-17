{ mkDerivation
, stdenv
, fetchurl
# native
, cmake
, extra-cmake-modules
, kdoctools
# not native
, qtxmlpatterns
, kconfig
, kconfigwidgets
, syntax-highlighting
, karchive
, kcrash
, knewstuff
, kparts
, ktexteditor
, poppler
, kpty
, libqalculate
, luajit
, analitza
, libspectre
}:

mkDerivation rec {
  pname = "cantor";
  version = "20.08.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/release-service/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "10jhf4k7ly12mcvkrpc3cfv8kfbsvfn0sf22xbq2jfgmhgvsnjqx";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    qtxmlpatterns
    poppler
    libqalculate
    luajit
    analitza
    libspectre
  ];

  propagatedBuildInputs = [
    kconfig
    kconfigwidgets
    syntax-highlighting
    karchive
    kcrash
    knewstuff
    kparts
    ktexteditor
    kpty
  ];
  # All tests fail due to Xorg not available.
  doCheck = false;

  meta = with stdenv.lib; {
    license = with stdenv.lib.licenses; [ gpl2 lgpl21 fdl12 ];
    homepage = "https://github.com/KDE/cantor";
    description = "Application that lets you use your favorite mathematical applications from within a nice KDE-integrated Worksheet Interface";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
