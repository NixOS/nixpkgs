{ stdenv, fetchurl, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/${name}.tar.gz";
    sha256 = "1z17wyrl5fp697qp44srpmzk79w37f5hm1r0krffbmga6sbzdj3x";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin pythonPackages.pync;

  NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}";

  postInstall = ''
    NIX_PYTHONPATH="$out/lib/${python.libPrefix}/site-packages"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    NIX_PYTHONPATH+="${pythonPackages.pync}/lib/${python.libPrefix}/site-packages"
  '' + ''
     wrapProgram "$out/bin/weechat" \
       --prefix PYTHONPATH : "$PYTHONPATH" \
       --prefix PYTHONPATH : "$NIX_PYTHONPATH"
  '';

  meta = {
    homepage = http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
