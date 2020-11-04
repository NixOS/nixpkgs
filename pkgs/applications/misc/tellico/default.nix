{ lib
, fetchurl
, mkDerivation
, libkcddb
, kinit
, kdelibs4support
, solid
, kxmlgui
, karchive
, kfilemetadata
, khtml
, knewstuff
, libksane
, cmake
, exempi
, extra-cmake-modules
, libcdio
, poppler
, makeWrapper
, kdoctools
, taglib
}:

mkDerivation rec {
  name = "tellico";
  version = "3.3.3";

  src = fetchurl {
    # version 3.3.0 just uses 3.3 in its name
    urls = [
      "https://tellico-project.org/files/tellico-${version}.tar.xz"
      "https://tellico-project.org/files/tellico-${lib.versions.majorMinor version}.tar.xz"
    ];
    sha256 = "sha256-9cdbUTa2Mt3/yNylOSdGjgDETD74sR0dU4C58uW0Y6o=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];

  buildInputs = [
    cmake
    exempi
    extra-cmake-modules
    karchive
    libkcddb
    kdelibs4support
    kfilemetadata
    khtml
    knewstuff
    kxmlgui
    libcdio
    libksane
    poppler
    solid
    taglib
  ];

  meta = with lib; {
    description = "Collection management software, free and simple";
    homepage = "https://tellico-project.org/";
    license = with licenses; [ gpl2 gpl3 ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.linux;
  };
}
