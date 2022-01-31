{ lib, stdenv, fetchFromGitLab
, libX11, libXcursor, libXext, libXi
, freetype, fontconfig
, libjpeg, libpng, libtiff, libwebp
, zlib
}:

stdenv.mkDerivation rec {
  pname = "azpainter";
  version = "3.0.4";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2gTTF1ti9bO24d75mhwyvJISSgMKdmp+oJVmgzEQHdY=";
  };

  buildInputs = [
    libX11 libXcursor libXext libXi
    freetype fontconfig
    libjpeg libpng libtiff libwebp
    zlib
  ];

  meta = with lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "https://osdn.net/projects/azpainter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = with platforms; linux ++ darwin;
  };
}
