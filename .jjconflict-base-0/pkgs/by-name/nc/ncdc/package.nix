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
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdc";
  version = "1.25";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${finalAttrs.version}.tar.gz";
    # Hashes listed at https://dev.yorhel.nl/download
    sha256 = "b9be58e7dbe677f2ac1c472f6e76fad618a65e2f8bf1c7b9d3d97bc169feb740";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    versionCheckHook
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

  doInstallCheck = true;

  meta = {
    changelog = "https://dev.yorhel.nl/ncdc/changes";
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "ncdc";
  };
})
