{ lib
, stdenv
, mkDerivation
, fetchurl
, cmake
, pkg-config
, hicolor-icon-theme
, openbabel
, desktop-file-utils
, qttranslations
}:

mkDerivation rec {
  pname = "molsketch";
  version = "0.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/molsketch/Molsketch-${version}-src.tar.gz";
    hash = "sha256-82iNJRiXqESwidjifKBf0+ljcqbFD1WehsXI8VUgrwQ=";
  };

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DMSK_PREFIX=$out"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    hicolor-icon-theme
    openbabel
    desktop-file-utils
    qttranslations
  ];

  meta = with lib; {
    description = "2D molecule editor";
    homepage = "https://sourceforge.net/projects/molsketch/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fortuneteller2k ];
  };
}
