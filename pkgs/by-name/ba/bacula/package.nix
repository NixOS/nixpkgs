{
  lib,
  stdenv,
  fetchurl,
  sqlite,
  libpq,
  zlib,
  acl,
  ncurses,
  openssl,
  readline,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bacula";
  version = "15.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/bacula/bacula-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-KUr9PS651bccPQ6I/fGetRO/24Q7KNNcBVLkrgYoJ6E=";
  };

  patches = [
    # ncurses 6.6 moved the termios.h include inside #ifdef NCURSES_INTERNALS in term.h,
    # so applications can no longer rely on term.h to provide termios symbols.
    ./0001-console-include-termios.h-explicitly.patch
  ];

  # libtool.m4 only matches macOS 10.*
  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace configure \
      --replace "10.*)" "*)"
  '';

  buildInputs = [
    libpq
    sqlite
    zlib
    ncurses
    openssl
    readline
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gettext # bacula requires CoreFoundation, but its `configure` script will only link it when it detects libintl.
  ]
  # acl relies on attr, which I can't get to build on darwin
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags = [
    "--with-sqlite3=${sqlite.dev}"
    "--with-postgresql=${lib.getDev libpq}"
    "--with-logdir=/var/log/bacula"
    "--with-working-dir=/var/lib/bacula"
    "--mandir=\${out}/share/man"
  ]
  ++
    lib.optional (stdenv.buildPlatform != stdenv.hostPlatform)
      "ac_cv_func_setpgrp_void=${lib.boolToYesNo (!stdenv.hostPlatform.isBSD)}"
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # bacula’s `configure` script fails to detect CoreFoundation correctly,
    # but these symbols are available in the nixpkgs CoreFoundation framework.
    "gt_cv_func_CFLocaleCopyCurrent=yes"
    "gt_cv_func_CFPreferencesCopyAppValue=yes"
  ];

  installFlags = [
    "logdir=\${out}/logdir"
    "working_dir=\${out}/workdir"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/sbin/* $out/bin
  '';

  meta = {
    description = "Enterprise ready, Network Backup Tool";
    homepage = "http://bacula.org/";
    license = with lib.licenses; [
      agpl3Only
      bsd2
    ];
    maintainers = with lib.maintainers; [
      lovek323
      eleanor
    ];
    platforms = lib.platforms.all;
  };
})
