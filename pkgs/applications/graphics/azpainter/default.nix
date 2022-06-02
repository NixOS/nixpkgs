{ lib, stdenv, fetchFromGitLab
, desktop-file-utils, shared-mime-info
, libiconv
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
    hash = "sha256-2gTTF1ti9bO24d75mhwyvJISSgMKdmp+oJVmgzEQHdY=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    shared-mime-info   # for update-mime-info
  ];

  buildInputs = [
    libX11 libXcursor libXext libXi
    freetype fontconfig
    libjpeg libpng libtiff libwebp
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "http://azsky2.html.xdomain.jp/soft/azpainter.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = with platforms; linux ++ darwin;
  };
}
