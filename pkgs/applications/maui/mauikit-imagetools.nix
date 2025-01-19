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

  meta = {
    homepage = "https://invent.kde.org/maui/mauikit-imagetools";
    description = "MauiKit Image Tools Components";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
