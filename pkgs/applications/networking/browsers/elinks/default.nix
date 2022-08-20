{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, xlibsWrapper, bzip2, zlib
, brotli, zstd, xz, openssl, autoreconfHook, gettext, pkg-config, libev
, gpm, libidn, tre, expat
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (!stdenv.isDarwin) && (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
# re-add javascript support when upstream supports modern spidermonkey
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "elinks";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "felinks";
    rev = "v${version}";
    sha256 = "sha256-9OEi4UF/4/IRtccJou3QuevQzWjA6PuU5IVlT7qqGZ0=";
  };

  buildInputs = [
    ncurses xlibsWrapper bzip2 zlib brotli zstd xz
    openssl libidn tre expat libev
  ]
    ++ lib.optional stdenv.isLinux gpm
    ++ lib.optional enableGuile guile
    ++ lib.optional enablePython python
    ++ lib.optional enablePerl perl
    ;

  nativeBuildInputs = [ autoreconfHook gettext pkg-config ];

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
  ] ++ lib.optional enableGuile        "--with-guile"
    ++ lib.optional enablePython       "--with-python"
    ++ lib.optional enablePerl         "--with-perl"
    ;

  meta = with lib; {
    description = "Full-featured text-mode web browser (package based on the fork felinks)";
    homepage = "https://github.com/rkd77/felinks";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ iblech gebner ];
  };
}
