{ stdenv, fetchurl, fetchpatch, ncurses, xlibsWrapper, bzip2, zlib, openssl
, gpm
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
, enableSpidermonkey ? (stdenv.hostPlatform == stdenv.buildPlatform), spidermonkey ? null
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "elinks";
  version = "0.12pre6";

  src = fetchurl {
    url = "http://elinks.or.cz/download/${pname}-${version}.tar.bz2";
    sha256 = "1nnakbi01g7yd3zqwprchh5yp45br8086b0kbbpmnclabcvlcdiq";
  };

  patches = [
    ./gc-init.patch
    ./openssl-1.1.patch
  ];

  postPatch = (stdenv.lib.optional stdenv.isDarwin) ''
    patch -p0 < ${fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/72bed7749e76b9092ddd8d9fe2d8449c5afb1d71/www/elinks/files/patch-perl.diff";
      sha256 = "14q9hk3kg2n2r5b062hvrladp7b4yzysvhq07903w9kpg4zdbyqh";
    }}
  '';

  buildInputs = [ ncurses xlibsWrapper bzip2 zlib openssl spidermonkey ]
    ++ stdenv.lib.optional stdenv.isLinux gpm
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

  meta = with stdenv.lib; {
    description = "Full-featured text-mode web browser";
    homepage = "http://elinks.or.cz";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };
}
