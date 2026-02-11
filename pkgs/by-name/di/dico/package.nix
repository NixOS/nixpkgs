{
  fetchurl,
  lib,
  stdenv,
  libtool,
  gettext,
  zlib,
  readline,
  gsasl,
  guile,
  python3,
  pcre,
  libffi,
  groff,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dico";
  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/dico/dico-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-couJxQ4JC/+Dno97MEO1xwI/hhqSEckwSLQqtFWGavc=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ groff ];

  buildInputs = [
    libtool
    gettext
    zlib
    readline
    gsasl
    guile
    python3
    pcre
    libffi
    libxcrypt
  ];

  strictDeps = true;

  # ERROR: All 188 tests were run, 90 failed unexpectedly.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Flexible dictionary server and client implementing RFC 2229";
    homepage = "https://www.gnu.org/software/dico/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    longDescription = ''
      GNU Dico is a flexible modular implementation of DICT server
      (RFC 2229).  In contrast to another existing servers, it does
      not depend on particular database format, instead it handles
      database accesses using loadable modules.

      The package includes several loadable modules for interfacing
      with various database formats, among them a module for dict.org
      databases and a module for transparently accessing Wikipedia or
      Wiktionary sites as a dictionary database.

      New modules can easily be written in C, Guile or Python.  The
      module API is mature and well documented.

      A web interface serving several databases is available.

      The package also includes a console client program for querying
      remote dictionary servers.
    '';
  };
})
