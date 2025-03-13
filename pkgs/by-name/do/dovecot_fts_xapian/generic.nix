{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
  pkg-config,
  xapian,
  icu,
  ...
}:
{
  # fts-xapian 1.9 is compatible with dovecot 2.2, 2.3 & 2.4
  # so no need for per-version hashes
  dovecot,
}:

stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    hash = "sha256-+8THyzzBV8QQVQFeKCSvIzkr5oaE0vdWU2gsolChfoo=";
  };

  buildInputs = [
    xapian
    icu
    sqlite
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    export PANDOC=false
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
  ];

  preInstall = ''
    sed -i 's/settingsdir = $(dovecot_moduledir)\/settings/settingsdir = $(moduledir)\/settings/' src/Makefile
    sed -i 's/echo " $(MKDIR_P) '\'''$(DESTDIR)$(dovecot_moduledir)'\'''";/echo " $(MKDIR_P) '\'''$(DESTDIR)$(moduledir)'\'''";/' src/Makefile
    sed -i 's/$(MKDIR_P) "$(DESTDIR)$(dovecot_moduledir)" || exit 1;/$(MKDIR_P) "$(DESTDIR)$(moduledir)" || exit 1;/' src/Makefile
    sed -i 's/echo " $(LIBTOOL) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=install $(INSTALL) $(INSTALL_STRIP_FLAG) $$list2 '\'''$(DESTDIR)$(dovecot_moduledir)'\'''";/echo " $(LIBTOOL) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=install $(INSTALL) $(INSTALL_STRIP_FLAG) $$list2 '\'''$(DESTDIR)$(moduledir)'\'''";/' src/Makefile
    sed -i 's/$(LIBTOOL) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=install $(INSTALL) $(INSTALL_STRIP_FLAG) $$list2 "$(DESTDIR)$(dovecot_moduledir)";/$(LIBTOOL) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=install $(INSTALL) $(INSTALL_STRIP_FLAG) $$list2 "$(DESTDIR)$(moduledir)";/' src/Makefile
  '';

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      julm
      symphorien
    ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
}
