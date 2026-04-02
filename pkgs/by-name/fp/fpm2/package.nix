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

stdenv.mkDerivation (finalAttrs: {
  pname = "fpm2";
  version = "0.90.1";

  src = fetchurl {
    url = "https://als.regnet.cz/fpm2/download/fpm2-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-G6PF5wlEc19jtqOxBTp/10dQiFYPDO/W6v9Oyzz1lZA=";
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

  meta = {
    description = "GTK2 port from Figaro's Password Manager originally developed by John Conneely, with some new enhancements";
    mainProgram = "fpm2";
    homepage = "https://als.regnet.cz/fpm2/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hce ];
  };
})
