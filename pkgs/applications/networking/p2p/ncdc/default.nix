{ lib, stdenv, fetchurl, fetchpatch, ncurses, zlib, bzip2, sqlite, pkg-config
, glib, gnutls, perl, libmaxminddb }:

stdenv.mkDerivation rec {
  pname = "ncdc";
  version = "1.23";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    hash = "sha256-gEq65B/MqWnof2UEg65+OiN0Gdq70yCJfiX+iFHwoss=";
  };

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs = [ ncurses zlib bzip2 sqlite glib gnutls libmaxminddb ];

  configureFlags = [ "--with-geoip" ];

  meta = with lib; {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdc";
    license = licenses.mit;
    platforms = platforms.linux; # arbitrary
    maintainers = with maintainers; [ ehmry ];
  };
}
