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
  postgresql,
  texinfo,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-dbd-postgresql";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "opencog";
    repo = "guile-dbi";
    tag = "guile-dbi-${finalAttrs.version}";
    hash = "sha256-nB6q/BPRIvzP83dJWnn7Bq6zZCNQ3pJ20MDEJZAkdYg=";
  };

  sourceRoot = "source/guile-dbd-postgresql";
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
    postgresql
    zlib
  ];

  postPatch = ''
    # PostgreSQL installs libpq's headers at the top of its include directory.
    substituteInPlace src/guile-dbd-postgresql.c \
      --replace-fail 'postgresql/libpq-fe.h' 'libpq-fe.h'
  '';

  meta = {
    homepage = "https://github.com/opencog/guile-dbi";
    description = "PostgreSQL driver for GNU Guile's database interface";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
