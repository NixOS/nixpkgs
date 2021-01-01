{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, ktexteditor, kwidgetsaddons, libkomparediff2,
  fetchpatch
}:

mkDerivation {
  name = "kompare";
  meta = { license = with lib.licenses; [ gpl2 ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kiconthemes kparts ktexteditor kwidgetsaddons libkomparediff2
  ];

  patches = [
    (fetchpatch {
      # Portaway from Obsolete methods of QPrinter
      # Part of v20.12.0
      url = "https://invent.kde.org/sdk/kompare/-/commit/68d3eee36c48a2f44ccfd3f9e5a36311b829104b.patch";
      sha256 = "B2i5n5cUDjCqTEF0OyTb1+LhPa5yWCnFycwijf35kwU=";
    })
  ];

  outputs = [ "out" "dev" ];
}
