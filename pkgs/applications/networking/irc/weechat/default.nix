{ stdenv, fetchurl, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile }:

stdenv.mkDerivation rec {
  version = "0.3.8";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/${name}.tar.gz";
    sha256 = "4293eb9d29f11b8ee8c301049d57e535acbea677bc1dc41ab12fe1bb8af0f10e";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile
    ];

  meta = {
    homepage = http://http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}

