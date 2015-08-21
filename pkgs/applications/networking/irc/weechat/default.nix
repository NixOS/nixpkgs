{ stdenv, fetchurl, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cmake, makeWrapper, libobjc, libiconv
, extraBuildInputs ? [] }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
    sha256 = "0j2ic1c69ksf78wi0cmc4yi5348x6c92g6annsx928sayxqxfgbh";
  };

  cmakeFlags = stdenv.lib.optional stdenv.isDarwin
    "-DICONV_LIBRARY=${libiconv}/lib/libiconv.dylib";

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cmake ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ pythonPackages.pync libobjc ]
    ++ extraBuildInputs;

  NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix} -DCA_FILE=/etc/ssl/certs/ca-certificates.crt";

  postInstall = ''
    NIX_PYTHONPATH="$out/lib/${python.libPrefix}/site-packages"
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
