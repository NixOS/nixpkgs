{ lib
, fetchurl
, mkDerivation
, cmake
, exempi
, extra-cmake-modules
, karchive
, kdoctools
, kfilemetadata
, khtml
, kitemmodels
, knewstuff
, kxmlgui
, libcdio
, libkcddb
, libksane
, makeWrapper
, poppler
, qtcharts
, qtwebengine
, solid
, taglib
}:

mkDerivation rec {
  pname = "tellico";
  version = "3.4.1";

  src = fetchurl {
    # version 3.3.0 just uses 3.3 in its file name
    urls = [
      "https://tellico-project.org/files/tellico-${version}.tar.xz"
      "https://tellico-project.org/files/tellico-${lib.versions.majorMinor version}.tar.xz"
    ];
    sha256 = "sha256-+FFN6sO0mvlage8JazyrqNZk4onejz1XJPiOK3gnhWE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];

  buildInputs = [
    exempi
    karchive
    kfilemetadata
    khtml
    kitemmodels
    knewstuff
    kxmlgui
    libcdio
    libkcddb
    libksane
    poppler
    qtcharts
    qtwebengine
    solid
    taglib
  ];

  meta = with lib; {
    description = "Collection management software, free and simple";
    homepage = "https://tellico-project.org/";
    license = with licenses; [ gpl2Only gpl3Only lgpl2Only ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.linux;
  };
}
