{ stdenv, fetchurl, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/${name}.tar.gz";
    sha256 = "17jxknam1bbakmdfqy1b2cfc8l9ag90l3z1gcxdvwg358wasv9dc";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake
    ];

  postInstall = ''
       wrapProgram "$out/bin/weechat-curses" \
         --prefix PYTHONPATH : "$PYTHONPATH" \
         --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages"
  '';

  meta = {
    homepage = http://http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}

