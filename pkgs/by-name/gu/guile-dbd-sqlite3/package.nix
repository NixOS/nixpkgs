{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  guile-dbi,
  libtool,
  perl,
  pkg-config,
  texinfo,
  sqlite,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-dbd-sqlite3";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "opencog";
    repo = "guile-dbi";
    tag = "guile-dbi-${finalAttrs.version}";
    hash = "sha256-nB6q/BPRIvzP83dJWnn7Bq6zZCNQ3pJ20MDEJZAkdYg=";
  };

  sourceRoot = "source/guile-dbd-sqlite3";
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    libtool
    perl
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    guile-dbi
    sqlite
    zlib
  ];

  meta = {
    homepage = "https://github.com/opencog/guile-dbi";
    description = "SQLite3 driver for GNU Guile's database interface";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
