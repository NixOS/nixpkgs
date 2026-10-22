{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  guile-dbi,
  libtool,
  mariadb-connector-c,
  perl,
  pkg-config,
  texinfo,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-dbd-mysql";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "opencog";
    repo = "guile-dbi";
    tag = "guile-dbi-${finalAttrs.version}";
    hash = "sha256-nB6q/BPRIvzP83dJWnn7Bq6zZCNQ3pJ20MDEJZAkdYg=";
  };

  sourceRoot = "source/guile-dbd-mysql";
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    libtool
    (lib.getDev mariadb-connector-c)
    perl
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    guile-dbi
    mariadb-connector-c
    zlib
  ];

  postPatch = ''
    # MariaDB's connector installs its headers as <mysql/…> and the library as
    # libmariadb, so look for that instead of the MySQL names.
    substituteInPlace configure.ac \
      --replace-fail mariadbclient mariadb
    substituteInPlace src/guile-dbd-mysql.c \
      --replace-fail '<mariadb/' '<mysql/'
  '';

  preConfigure = ''
    # The connector keeps libmariadb.so in lib/mariadb, which is not in the
    # linker's default search path; configure looks for it before it starts
    # using mariadb_config's flags.
    export LIBS="-L${lib.getLib mariadb-connector-c}/lib/mariadb ''${LIBS:-}"
  '';

  meta = {
    homepage = "https://github.com/opencog/guile-dbi";
    description = "MariaDB/MySQL driver for GNU Guile's database interface";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
