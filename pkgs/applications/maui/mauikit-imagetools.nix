{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kconfig
, kio
, mauikit
, qtlocation
, exiv2
, kquickimageedit
}:

mkDerivation {
  pname = "mauikit-imagetools";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
    qtlocation
    exiv2
    kquickimageedit
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-imagetools";
    description = "MauiKit Image Tools Components";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ onny ];
  };
}
