{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kio,
  leptonica,
  mauikit,
  opencv,
  qtlocation,
  exiv2,
  kquickimageedit,
  tesseract,
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
    leptonica
    mauikit
    opencv
    qtlocation
    exiv2
    kquickimageedit
    tesseract
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-imagetools";
    description = "MauiKit Image Tools Components";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ onny ];
  };
}
