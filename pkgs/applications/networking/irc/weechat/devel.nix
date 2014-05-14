{ stdenv, fetchgit, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  rev = "70d2b0ad8eb7854932d24c007a05b8627f751205";
  version = "1.0-rev${rev}";
  name = "weechat-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/weechat/weechat.git";
    sha256 = "1k7kcrq46anq87r14sq3vrhij8acn6id7zxyhn0qnjj2wqgrjp5i";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin pythonPackages.pync;

  NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}";

  postInstall = ''
    NIX_PYTHON_PATH="$out/lib/${python.libPrefix}/site-packages"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    NIX_PYTHON_PATH+="${pythonPackages.pync}/lib/${python.libPrefix}/site-packages"
  '' + ''
     wrapProgram "$out/bin/weechat" \
       --prefix PYTHONPATH : "$PYTHONPATH" \
       --prefix PYTHONPATH : "$NIX_PYTHONPATH"
  '';

  meta = {
    homepage    = http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license     = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
