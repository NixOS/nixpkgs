{ stdenv, fetchgit, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  rev = "124b2668fe4e97e3926caea85ed2c9f7082c4df9";
  version = "1.0-rev${rev}";
  name = "weechat-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/weechat/weechat.git";
    sha256 = "1xl5scyrxmyqaycpalhl3j50s65w2gjdm43vahd618yyykdffr8b";
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
