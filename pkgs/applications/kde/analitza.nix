{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, qtbase
, qtsvg
, eigen
, kdoctools
, qttools
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

  meta = with lib; {
    description = "Front end to powerful mathematics and statistics packages";
    homepage = "https://cantor.kde.org/";
    license = with licenses; [ gpl2Only lgpl2Only fdl12Only ];
    maintainers = with maintainers; [ hqurve ];
  };
}
