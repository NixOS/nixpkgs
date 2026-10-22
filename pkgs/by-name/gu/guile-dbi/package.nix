{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  libtool,
  perl,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-dbi";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "opencog";
    repo = "guile-dbi";
    tag = "guile-dbi-${finalAttrs.version}";
    hash = "sha256-nB6q/BPRIvzP83dJWnn7Bq6zZCNQ3pJ20MDEJZAkdYg=";
  };

  sourceRoot = "source/guile-dbi";
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
  propagatedBuildInputs = [
    guile
  ];

  configureFlags = [
    "--with-guile-site-dir=${placeholder "out"}/${guile.siteDir}"
  ];

  postInstall = ''
    substituteInPlace $out/${guile.siteDir}/dbi/dbi.scm \
      --replace-fail '"libguile-dbi"' '"${placeholder "out"}/lib/libguile-dbi"'
  '';

  meta = {
    homepage = "https://github.com/opencog/guile-dbi";
    description = "Generic database access library for GNU Guile";
    longDescription = ''
      guile-dbi provides a generic, easy-to-use Scheme interface to SQL
      databases.  The database-independent part provides the Scheme interface,
      while database-dependent plugins (guile-dbd-sqlite3, guile-dbd-mysql and
      guile-dbd-postgresql) connect to an actual database server.  The plugins
      are looked up at run time through the GUILE_DBD_PATH environment
      variable.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
