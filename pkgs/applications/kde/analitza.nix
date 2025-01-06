{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  qtsvg,
  eigen,
  kdoctools,
  qttools,
}:

mkDerivation {
  pname = "analitza";

  nativeBuildInputs = [
    cmake
    eigen
    extra-cmake-modules
    kdoctools
    qttools
  ];

  buildInputs = [
    qtbase
    qtsvg
  ];

  meta = {
    description = "Front end to powerful mathematics and statistics packages";
    homepage = "https://cantor.kde.org/";
    license = with lib.licenses; [
      gpl2Only
      lgpl2Only
      fdl12Only
    ];
    maintainers = with lib.maintainers; [ hqurve ];
  };
}
