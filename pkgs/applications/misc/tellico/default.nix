{ lib
, fetchurl
, mkDerivation
, kdeApplications
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
}:

mkDerivation rec {
  name = "tellico";
  version = "3.3.0";

  src = fetchurl {
    url = "https://tellico-project.org/files/tellico-${lib.versions.majorMinor version}.tar.xz";
    sha256 = "1digkpvzrsbv5znf1cgzs6zkmysfz6lzs12n12mrrpgkcdxc426y";
  };

  patches = [
    ./hex.patch
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    makeWrapper
  ];

  buildInputs = [
    kdelibs4support
    solid
    kxmlgui
    karchive
    kfilemetadata
    khtml
    knewstuff
    libksane
    cmake
    exempi
    extra-cmake-modules
    libcdio
    kdeApplications.libkcddb
    poppler
  ];

  meta = {
    description = "Collection management software, free and simple";
    homepage = "https://tellico-project.org/";
    maintainers = with lib.maintainers; [ numkem ];
    license = with lib.licenses; [ gpl2 gpl3 ];
    platforms = lib.platforms.linux;
  };
}
