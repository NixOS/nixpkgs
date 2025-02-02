{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  imlib2,
  file,
  lcms2,
  libexif,
}:

stdenv.mkDerivation (rec {
  version = "2.3.3";
  pname = "qiv";

  src = fetchurl {
    url = "https://spiegl.de/qiv/download/${pname}-${version}.tgz";
    sha256 = "sha256-7whf/eLUiwWzZlk55a4eNZ06OBAI+4J2hPfW/UxTNwQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    imlib2
    file
    lcms2
    libexif
  ];

  preBuild = ''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
    substituteInPlace Makefile --replace /share/share/ /share/
  '';

  meta = with lib; {
    description = "Quick image viewer";
    homepage = "http://spiegl.de/qiv/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "qiv";
  };
})
