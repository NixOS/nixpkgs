{ lib
, mkDerivation
, fetchurl
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, hicolor-icon-theme
, openbabel
, desktop-file-utils
}:

mkDerivation rec {
  pname = "molsketch";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/molsketch/Molsketch-${version}-src.tar.gz";
    hash = "sha256-Mpx4fHktxqBAkmdwqg2pXvEgvvGUQPbgqxKwXKjhJuQ=";
  };

  # uses C++17 APIs like std::transform_reduce
  postPatch = ''
    substituteInPlace molsketch/CMakeLists.txt \
      --replace "CXX_STANDARD 14" "CXX_STANDARD 17"
    substituteInPlace libmolsketch/CMakeLists.txt \
      --replace "CXX_STANDARD 14" "CXX_STANDARD 17"
    substituteInPlace obabeliface/CMakeLists.txt \
      --replace "CXX_STANDARD 14" "CXX_STANDARD 17"
  '';

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DMSK_PREFIX=$out"
  '';

  postFixup = ''
    mv $out/lib/molsketch/* $out/lib
  '';

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];
  buildInputs = [
    hicolor-icon-theme
    openbabel
    desktop-file-utils
  ];

  meta = with lib; {
    description = "2D molecule editor";
    homepage = "https://sourceforge.net/projects/molsketch/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.moni ];
    mainProgram = "molsketch";
  };
}
