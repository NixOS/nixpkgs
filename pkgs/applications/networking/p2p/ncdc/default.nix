{ lib, stdenv, fetchurl, fetchpatch, ncurses, zlib, bzip2, sqlite, pkg-config
, glib, gnutls, perl, libmaxminddb }:

stdenv.mkDerivation rec {
  pname = "ncdc";
  version = "1.23.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    hash = "sha256-lYgSFAd6Wzwk+7rwIK2g0ITuO1lqfDzB4OaKqsTJteY=";
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
