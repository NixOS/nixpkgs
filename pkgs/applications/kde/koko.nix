{
  lib,
  mkDerivation,

  fetchurl,
  cmake,
  extra-cmake-modules,

  exiv2,
  kconfig,
  kcoreaddons,
  kdeclarative,
  kfilemetadata,
  kguiaddons,
  ki18n,
  kio,
  kirigami2,
  knotifications,
  kpurpose,
  kquickimageedit,
  qtgraphicaleffects,
  qtlocation,
  qtquickcontrols2,
}:

let
  # URLs snapshotted through
  # https://web.archive.org/save/$url
  # Update when stale enough I guess?
  admin1 = fetchurl {
    url = "https://web.archive.org/web/20210714035424if_/http://download.geonames.org/export/dump/admin1CodesASCII.txt";
    sha256 = "0r783yzajs26hvccdy4jv2v06xfgadx2g90fz3yn7lx8flz4nhwm";
  };
  admin2 = fetchurl {
    url = "https://web.archive.org/web/20210714035427if_/http://download.geonames.org/export/dump/admin2Codes.txt";
    sha256 = "1n5nzp3xblhr93rb1sadi5vfbw29slv5lc6cxq21h3x3cg0mwqh3";
  };
  cities1000 = fetchurl {
    url = "https://web.archive.org/web/20210714035406if_/http://download.geonames.org/export/dump/cities1000.zip";
    sha256 = "0cwbfff8gzci5zrahh6d53b9b3bfv1cbwlv0k6076531i1c7md9p";
  };
in
mkDerivation rec {
  pname = "koko";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    exiv2
    kconfig
    kcoreaddons
    kdeclarative
    kfilemetadata
    kguiaddons
    ki18n
    kio
    kirigami2
    knotifications
    kpurpose
    kquickimageedit
    qtgraphicaleffects
    qtlocation
    qtquickcontrols2
  ];

  prePatch = ''
    ln -s ${admin1}     src/admin1CodesASCII.txt
    ln -s ${admin2}     src/admin2Codes.txt
    ln -s ${cities1000} src/cities1000.zip
  '';

  meta = with lib; {
    description = "Image gallery mobile application";
    mainProgram = "koko";
    homepage = "https://apps.kde.org/koko/";
    # LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    license = [
      licenses.lgpl3Only
      licenses.lgpl21Only
    ];
    maintainers = with maintainers; [ samueldr ];
  };
}
