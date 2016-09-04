{ stdenv, fetchurl, perl, ncurses, xlibsWrapper, bzip2, zlib, openssl
, spidermonkey, gpm
, enableGuile ? false, guile ? null   # Incompatible licenses, LGPLv3 - GPLv2
, enablePython ? false, python ? null
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "elinks-0.12pre6";

  src = fetchurl {
    url = http://elinks.or.cz/download/elinks-0.12pre6.tar.bz2;
    sha256 = "1nnakbi01g7yd3zqwprchh5yp45br8086b0kbbpmnclabcvlcdiq";
  };

  patches = [ ./gc-init.patch ];

  buildInputs = [ perl ncurses xlibsWrapper bzip2 zlib openssl spidermonkey gpm ]
    ++ stdenv.lib.optional enableGuile guile
    ++ stdenv.lib.optional enablePython python;

  configureFlags =
    ''
      --enable-finger --enable-html-highlight
      --with-perl --enable-gopher --enable-cgi --enable-bittorrent
      --with-spidermonkey=${spidermonkey}
      --enable-nntp --with-openssl=${openssl.dev}
    '' + stdenv.lib.optionalString enableGuile " --with-guile"
    + stdenv.lib.optionalString enablePython " --with-python";

  crossAttrs = {
    propagatedBuildInputs = [ ncurses.crossDrv zlib.crossDrv openssl.crossDrv ];
    configureFlags = ''
      --enable-finger --enable-html-highlight
      --enable-gopher --enable-cgi --enable-bittorrent --enable-nntp
      --with-openssl=${openssl.crossDrv}
      --with-bzip2=${bzip2.crossDrv}
    '';
  };

  meta = {
    description = "Full-featured text-mode web browser";
    homepage = http://elinks.or.cz;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
