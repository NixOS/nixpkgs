{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  dejagnu,
  gettext,
  gnum4,
  pkg-config,
  texinfo,
  fribidi,
  gdbm,
  gnutls,
  gss,
  guile,
  libmysqlclient,
  mailcap,
  net-tools,
  pam,
  readline,
  ncurses,
  python3,
  gsasl,
  system-sendmail,
  libxcrypt,
  mkpasswd,

  pythonSupport ? true,
  guileSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mailutils";
  version = "3.19";

  src = fetchurl {
    url = "mirror://gnu/mailutils/mailutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-UCMNIANsW4rYyWsNmWF38fEz+6THx+O0YtOe6zCEn0U=";
  };

  separateDebugInfo = true;

  postPatch = ''
    sed -i -e '/chown root:mail/d' \
           -e 's/chmod [24]755/chmod 0755/' \
      */Makefile{.in,.am}
    sed -i 's:/usr/lib/mysql:${libmysqlclient}/lib/mysql:' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gnum4
    pkg-config
    texinfo
  ];

  buildInputs = [
    fribidi
    gdbm
    gnutls
    gss
    libmysqlclient
    mailcap
    ncurses
    pam
    readline
    gsasl
    libxcrypt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ net-tools ]
  ++ lib.optionals pythonSupport [ python3 ]
  ++ lib.optionals guileSupport [ guile ];

  patches = [
    ./fix-build-mb-len-max.patch
    ./path-to-cat.patch
    # Fix cross-compilation
    # https://lists.gnu.org/archive/html/bug-mailutils/2020-11/msg00038.html
    (fetchpatch {
      url = "https://lists.gnu.org/archive/html/bug-mailutils/2020-11/txtiNjqcNpqOk.txt";
      hash = "sha256-2rhuopBANngq/PRCboIr+ewdawr8472cYwiLjtHCHz4=";
    })
    # Avoid hardeningDisable = [ "format" ]; - this patch is from the project's master branch and can be removed at the next version
    (fetchpatch {
      url = "https://cgit.git.savannah.gnu.org/cgit/mailutils.git/patch/?id=9379ec9e25ae6bdbd3d6f5ef9930ac2176d2efe7";
      hash = "sha256-00R1DLMDPsvz3R6UgRO1ZvgMNCiHYS3lfjqAC9VD+Y4=";
    })
    # https://github.com/NixOS/nixpkgs/issues/223967
    # https://lists.gnu.org/archive/html/bug-mailutils/2023-04/msg00000.html
    ./don-t-use-descrypt-password-in-the-test-suite.patch
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-gssapi"
    "--with-gsasl"
    "--with-mysql"
    "--with-path-sendmail=${system-sendmail}/bin/sendmail"
    "--with-mail-rc=/etc/mail.rc"
    "DEFAULT_CUPS_CONFDIR=${mailcap}/etc" # provides mime.types to mimeview
  ]
  ++ lib.optional (!pythonSupport) "--without-python"
  ++ lib.optional (!guileSupport) "--without-guile";

  nativeCheckInputs = [
    dejagnu
    mkpasswd
  ];

  doCheck = !stdenv.hostPlatform.isDarwin; # ERROR: All 46 tests were run, 46 failed unexpectedly.

  meta = {
    description = "Rich and powerful protocol-independent mail framework";

    longDescription = ''
      GNU Mailutils is a rich and powerful protocol-independent mail
      framework.  It contains a series of useful mail libraries, clients, and
      servers.  These are the primary mail utilities for the GNU system.  The
      central library is capable of handling electronic mail in various
      mailbox formats and protocols, both local and remote.  Specifically,
      this project contains a POP3 server, an IMAP4 server, and a Sieve mail
      filter.  It also provides a POSIX `mailx' client, and a collection of
      other handy tools.

      The GNU Mailutils libraries supply an ample set of primitives for
      handling electronic mail in programs written in C, C++, Python or
      Scheme.

      The utilities provided by Mailutils include imap4d and pop3d mail
      servers, mail reporting utility comsatd, mail filtering program sieve,
      and an implementation of MH message handling system.
    '';

    license = with lib.licenses; [
      lgpl3Plus # libraries
      gpl3Plus # tools
    ];

    maintainers = [ ];

    homepage = "https://www.gnu.org/software/mailutils/";
    changelog = "https://git.savannah.gnu.org/cgit/mailutils.git/tree/NEWS";

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = lib.platforms.gnu ++ lib.platforms.unix;
  };
})
