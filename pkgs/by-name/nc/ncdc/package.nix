{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  zlib,
  bzip2,
  sqlite,
  pkg-config,
  glib,
  gnutls,
  perl,
  libmaxminddb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdc";
  version = "1.24.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${finalAttrs.version}.tar.gz";
    hash = "sha256-Koq5rX1D8Bj8c7qLq9aJ36RKuozsU7iOR3AYXLl3ePc=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    ncurses
    zlib
    bzip2
    sqlite
    glib
    gnutls
    libmaxminddb
  ];

  configureFlags = [ "--with-geoip" ];

  meta = {
    changelog = "https://dev.yorhel.nl/ncdc/changes";
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "ncdc";
  };
})
