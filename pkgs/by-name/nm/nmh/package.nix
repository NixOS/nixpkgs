{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  coreutils,
  cyrus_sasl,
  db,
  fetchFromSavannah,
  flex,
  gdbm,
  liblockfile,
  ncurses,
  openssl,
  readline,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nmh";
  version = "1.7.1";
  src = fetchFromSavannah {
    repo = "nmh";
    rev = finalAttrs.version;
    hash = "sha256-sBftXl4hWs4bKw5weHkif1KIJBpheU/RCePx0WXuv9o=";
  };

  postPatch = ''
    substituteInPlace config/config.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace \
      sbr/arglist.c \
      uip/mhbuildsbr.c \
      uip/whatnowsbr.c \
      uip/slocal.c \
      --replace '"/bin/sh"' '"${runtimeShell}"'
    # the "cleanup" pseudo-test makes diagnosing test failures a pain
    ln -s -f ${stdenv}/bin/true test/cleanup
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

  NIX_CFLAGS_COMPILE = "-Wno-stringop-truncation";
  doCheck = true;
  enableParallelBuilding = true;

  meta = {
    description = "New MH Mail Handling System";
    homepage = "https://nmh.nongnu.org/";
    downloadPage = "http://download.savannah.nongnu.org/releases/nmh/";
    changelog = "http://savannah.nongnu.org/news/?group=nmh";
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
  };

})
