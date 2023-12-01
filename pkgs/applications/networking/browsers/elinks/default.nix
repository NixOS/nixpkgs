{ lib, stdenv, fetchFromGitHub, ncurses, libX11, bzip2, zlib
, brotli, zstd, xz, openssl, autoreconfHook, gettext, pkg-config, libev
, gpm, libidn, tre, expat
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (!stdenv.isDarwin) && (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
, fetchpatch
# re-add javascript support when upstream supports modern spidermonkey
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "elinks";
  version = "0.16.1.1";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "felinks";
    rev = "v${version}";
    sha256 = "sha256-u6QGhfi+uWeIzSUFuYHAH3Xu0Fky0yw2h4NOKgYFLsM=";
  };

  patches = [
    # Fix build bug with perl 5.38.0. Backport of https://github.com/rkd77/elinks/pull/243 by gentoo:
    # https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=dfefaa456bd69bc14e3a1c2c6c1b0cc19c6b0869
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/www-client/elinks/files/elinks-0.16.1.1-perl-5.38.patch?id=dfefaa456bd69bc14e3a1c2c6c1b0cc19c6b0869";
      hash = "sha256-bHP9bc/l7VEw7oXlkSUQhhuq8rT2QTahh9SM7ZJgK5w=";
    })
  ];

  buildInputs = [
    ncurses libX11 bzip2 zlib brotli zstd xz
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
    "--enable-gemini"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--enable-256-colors"
    "--enable-true-color"
    "--with-brotli"
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
