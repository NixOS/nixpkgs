{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mkDerivation
, fetchurl
, cmake
, pkg-config
<<<<<<< HEAD
, qttools
, wrapQtAppsHook
, hicolor-icon-theme
, openbabel
, desktop-file-utils
=======
, hicolor-icon-theme
, openbabel
, desktop-file-utils
, qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation rec {
  pname = "molsketch";
<<<<<<< HEAD
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

=======
  version = "0.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/molsketch/Molsketch-${version}-src.tar.gz";
    hash = "sha256-82iNJRiXqESwidjifKBf0+ljcqbFD1WehsXI8VUgrwQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preConfigure = ''
    cmakeFlags="$cmakeFlags -DMSK_PREFIX=$out"
  '';

<<<<<<< HEAD
  postFixup = ''
    mv $out/lib/molsketch/* $out/lib
  '';

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];
=======
  nativeBuildInputs = [ cmake pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    hicolor-icon-theme
    openbabel
    desktop-file-utils
<<<<<<< HEAD
=======
    qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "2D molecule editor";
    homepage = "https://sourceforge.net/projects/molsketch/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fortuneteller2k ];
  };
}
