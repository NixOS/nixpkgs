{ stdenv, fetchurl, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/${name}.tar.gz";
    sha256 = "1sfx2j8xy6das0zis2nmzi9z41q96gzq61xaw4i0xbgag17s7ddz";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin pythonPackages.pync;

  # This patch is based on
  # weechat/c324610226cef15ecfb1235113c8243b068084c8. It fixes
  # freeze/crash on /exit when using nixpkgs' gnutls 3.2. The next
  # weechat release (0.4.4) will include this, so it's safe to remove
  # then.
  patches = [ ./fix-gnutls-32.diff ];

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
