{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {

  version = "0.8.21";
  name = "irssi-${version}";

  src = fetchurl {
    urls = [ "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz" ];
    sha256 = "0fxacadhdzl3n0231mqjv2gcmj1fj85azhbbsk0fq7xmf1da7ha2";
  };

  buildInputs = [ pkgconfig ncurses glib openssl perl libintlOrEmpty ];

  NIX_LDFLAGS = ncurses.ldflags;

  configureFlags = "--with-proxy --with-ncurses --enable-ssl --with-perl=yes";

  meta = {
    homepage    = http://irssi.org;
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}
