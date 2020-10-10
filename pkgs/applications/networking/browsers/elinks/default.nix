{ stdenv, fetchFromGitHub, fetchpatch, ncurses, xlibsWrapper, bzip2, zlib
, brotli, zstd, lzma, openssl, autoreconfHook, gettext, pkgconfig, libev
, gpm, libidn, tre, expat
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
# re-add javascript support when upstream supports modern spidermonkey
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "elinks";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "felinks";
    rev = "v${version}";
    sha256 = "067l9m47j40039q8mvvnxd1amwrac3x6vv0c0svimfpvj4ammgkg";
  };

  buildInputs = [
    ncurses xlibsWrapper bzip2 zlib brotli zstd lzma
    openssl libidn tre expat libev
  ]
    ++ stdenv.lib.optional stdenv.isLinux gpm
    ++ stdenv.lib.optional enableGuile guile
    ++ stdenv.lib.optional enablePython python
    ++ stdenv.lib.optional enablePerl perl
    ;

  nativeBuildInputs = [ autoreconfHook gettext pkgconfig ];

  configureFlags = [
    "--enable-finger"
    "--enable-html-highlight"
    "--enable-gopher"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--enable-256-colors"
    "--enable-true-color"
    "--with-lzma"
    "--with-libev"
    "--with-terminfo"
  ] ++ stdenv.lib.optional enableGuile        "--with-guile"
    ++ stdenv.lib.optional enablePython       "--with-python"
    ++ stdenv.lib.optional enablePerl         "--with-perl"
    ;

  meta = with stdenv.lib; {
    description = "Full-featured text-mode web browser (package based on the fork felinks)";
    homepage = "https://github.com/rkd77/felinks";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ iblech gebner ];
  };
}
