{ stdenv, fetchurl, ncurses, xlibsWrapper, bzip2, zlib, openssl
, gpm
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
, enableSpidermonkey ? (stdenv.hostPlatform == stdenv.buildPlatform), spidermonkey ? null
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation {
  name = "elinks-0.12pre6";

  src = fetchurl {
    url = http://elinks.or.cz/download/elinks-0.12pre6.tar.bz2;
    sha256 = "1nnakbi01g7yd3zqwprchh5yp45br8086b0kbbpmnclabcvlcdiq";
  };

  patches = [
    ./gc-init.patch
    ./openssl-1.1.patch
  ];

  buildInputs = [ ncurses xlibsWrapper bzip2 zlib openssl spidermonkey gpm ]
    ++ stdenv.lib.optional enableGuile guile
    ++ stdenv.lib.optional enablePython python
    ++ stdenv.lib.optional enablePerl perl
    ;

  configureFlags = [
    "--enable-finger"
    "--enable-html-highlight"
    "--enable-gopher"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--with-openssl=${openssl.dev}"
    "--with-bzip2=${bzip2.dev}"
  ] ++ stdenv.lib.optional enableGuile        "--with-guile"
    ++ stdenv.lib.optional enablePython       "--with-python"
    ++ stdenv.lib.optional enablePerl         "--with-perl"
    ++ stdenv.lib.optional enableSpidermonkey "--with-spidermonkey=${spidermonkey}"
    ;

  meta = {
    description = "Full-featured text-mode web browser";
    homepage = http://elinks.or.cz;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
