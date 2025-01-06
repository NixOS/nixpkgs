{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnupg,
  gtk3,
  libxml2,
  intltool,
  nettle,
}:

stdenv.mkDerivation rec {
  pname = "fpm2";
  version = "0.90";

  src = fetchurl {
    url = "https://als.regnet.cz/fpm2/download/fpm2-${version}.tar.xz";
    sha256 = "1lfzja3vzd6l6hfvw8gvg4qkl5iy6gra5pa8gjlps9l63k2bjfhz";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    gnupg
    gtk3
    libxml2
    nettle
  ];

  meta = with lib; {
    description = "GTK2 port from Figaro's Password Manager originally developed by John Conneely, with some new enhancements";
    mainProgram = "fpm2";
    homepage = "https://als.regnet.cz/fpm2/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hce ];
  };
}
