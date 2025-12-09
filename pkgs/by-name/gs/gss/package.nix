{
  lib,
  stdenv,
  fetchzip,
  autoconf,
  automake,
  gengetopt,
  gettext,
  gnulib,
  gtk-doc,
  help2man,
  libtool,
  perl,
  texinfo,
  withShishi ? !stdenv.hostPlatform.isDarwin,
  shishi,
}:

stdenv.mkDerivation rec {
  pname = "gss";
  version = "1.0.4";

  # The dist tarballs do not contain everything necessary to
  # autoreconf.  Trying to use autoreconfHook with a dist tarball
  # produces a broken result that fails to build for some platforms.
  # If we want to autoreconf, we need to build from a git snapshot.
  #
  # See this explanation from the maintainer, about an existing
  # package that exhibits the same problem (that we were able to
  # produce when building for Darwin an musl.)
  #
  # https://lists.gnu.org/archive/html/help-libidn/2021-07/msg00009.html
  src = fetchzip {
    url = "https://gitweb.git.savannah.gnu.org/gitweb/?p=gss.git;a=snapshot;h=v${version};sf=tgz";
    extension = "tar.gz";
    hash = "sha256-yT19kwAhGzbIoMjRbrrsn6CyvkMH5v1nxxWpnGYmZUw=";
  };

  env = {
    GNULIB_SRCDIR = gnulib.src;
  };

  # krb5context test uses certificates that expired on 2024-07-11.
  # Reported to bug-gss@gnu.org with Message-ID: <87cyngavtt.fsf@alyssa.is>.
  postPatch = ''
    rm tests/krb5context.c
  '';

  nativeBuildInputs = [
    autoconf
    automake
    gengetopt
    gettext
    gtk-doc
    help2man
    libtool
    perl
    texinfo
  ];

  buildInputs = lib.optional withShishi shishi;

  preConfigure = ''
    patchShebangs doc/gdoc
    ./autogen.sh
  '';

  configureFlags = [
    "--${if withShishi then "enable" else "disable"}-kerberos5"
  ];

  # Fixup .la files
  postInstall = lib.optionalString withShishi ''
    sed -i 's,\(-lshishi\),-L${shishi}/lib \1,' $out/lib/libgss.la
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gss/";
    description = "Generic Security Service";
    mainProgram = "gss";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
