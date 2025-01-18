{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  karchive,
  kconfig,
  kcoreaddons,
  kfilemetadata,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  mauikit,
  poppler,
}:

mkDerivation {
  pname = "mauikit-documents";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    karchive
    kconfig
    kcoreaddons
    kfilemetadata
    kguiaddons
    ki18n
    kiconthemes
    kio
    mauikit
    poppler
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-documents";
    description = "MauiKit QtQuick plugins for text editing";
    license = with licenses; [
      bsd2
      lgpl21Plus
    ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
