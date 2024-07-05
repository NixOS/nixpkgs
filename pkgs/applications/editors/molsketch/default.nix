{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, hicolor-icon-theme
, openbabel
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "molsketch";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/molsketch/Molsketch-${version}-src.tar.gz";
    hash = "sha256-6wFvl3Aktv8RgEdI2ENsKallKlYy/f8Tsm5C0FB/igI=";
  };

  patches = [
    ./openbabel.patch
  ];

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
    ln -s $out/lib/molsketch/* $out/lib/.
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
    platforms = platforms.unix;
  };
}
