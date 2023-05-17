{ lib
, mkDerivation
, fetchpatch
, cmake
, extra-cmake-modules
, kconfig
, kio
, leptonica
, mauikit
, opencv
, qtlocation
, exiv2
, kquickimageedit
, tesseract
}:

mkDerivation {
  pname = "mauikit-imagetools";

  patches = [
    (fetchpatch {
      name = "remove-unused-method.patch";
      url = "https://invent.kde.org/maui/mauikit-imagetools/-/commit/344852044d407b144bca01c41a409ceaa548bec0.patch";
      hash = "sha256-Cpq/XzDgrKD8YVex2z9VxGTA+iDI5703+fHwkn0cIWA=";
    })
  ];

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
