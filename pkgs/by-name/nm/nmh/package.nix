{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  cyrus_sasl,
  db,
  fetchurl,
  flex,
  gdbm,
  liblockfile,
  ncurses,
  openssl,
  readline,
  runtimeShell,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nmh";
  version = "1.8";

  src = fetchurl {
    url = "mirror://savannah/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-Nmzgzj+URzAvVWcAkmnIuziC2AjzPu+shbo2fodchhU=";
  };

  patches = [ ./reproducible-build-date.patch ];

  postPatch =
    # patch hardcoded shell
    ''
      substituteInPlace \
        sbr/arglist.c \
        uip/mhbuildsbr.c \
        uip/whatnowsbr.c \
        uip/slocal.c \
        --replace-fail '"/bin/sh"' '"${runtimeShell}"'
    ''
    # the "cleanup" pseudo-test makes diagnosing test failures a pain
    + ''
      ln -sf ${stdenv}/bin/true test/cleanup
    '';

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
  ];

  buildInputs = [
    cyrus_sasl
    db
    gdbm
    liblockfile
    ncurses
    openssl
    readline
  ];

  doCheck = true;
  enableParallelBuilding = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/install-mh";
  versionCheckProgramArg = "-version";

  meta = {
    description = "New MH Mail Handling System";
    homepage = "https://nmh.nongnu.org/";
    downloadPage = "https://download.savannah.nongnu.org/releases/nmh/";
    changelog = "https://savannah.nongnu.org/news/?group=nmh";
    license = [ lib.licenses.bsd3 ];
    longDescription = ''
      This is the nmh mail user agent (reader/sender), a command-line based
      mail reader that is powerful and extensible.  nmh is an excellent choice
      for people who receive and process a lot of mail.

      Unlike most mail user agents, nmh is not a single program, rather it is
      a set of programs that are run from the shell.  This allows the user to
      utilize the full power of the Unix shell in coordination with nmh.
      Various front-ends are available, such as mh-e (an emacs mode), xmh, and
      exmh (X11 clients).

      nmh was originally based on MH version 6.8.3, and is intended to be a
      (mostly) compatible drop-in replacement for MH.

      These tools are mainly useful for writing scripts that manipulating
      claws-mail's mail folders.  Most other mail clients have migrated to
      maildir.
    '';
    maintainers = with lib.maintainers; [ normalcea ];
  };

})
