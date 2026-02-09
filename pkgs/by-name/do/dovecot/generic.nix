{
  version,
  hash,
  patches,
}:
{
  stdenv,
  lib,
  fetchzip,
  flex,
  bison,
  perl,
  pkg-config,
  systemd,
  openssl,
  bzip2,
  lz4,
  zlib,
  zstd,
  xz,
  inotify-tools,
  pam,
  libcap,
  coreutils,
  clucene-core_2,
  icu75,
  libexttextcat,
  libsodium,
  libxcrypt,
  libstemmer,
  cyrus_sasl,
  nixosTests,
  fetchpatch,
  rpcsvc-proto,
  libtirpc,
  dovecot_pigeonhole,
  withApparmor ? false,
  libapparmor,
  withLDAP ? true,
  openldap,
  withPCRE2 ? lib.strings.versionAtLeast version "2.4",
  pcre2,
  withUnwind ? false,
  libunwind,
  # Auth modules
  withMySQL ? false,
  libmysqlclient,
  withPgSQL ? false,
  libpq,
  withSQLite ? true,
  sqlite,
  withLua ? false,
  lua5_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dovecot";
  inherit version;

  nativeBuildInputs = [
    flex
    bison
    perl
    pkg-config
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isDarwin) [ rpcsvc-proto ];

  buildInputs = [
    openssl
    bzip2
    lz4
    zlib
    zstd
    xz
    clucene-core_2
    icu75
    libexttextcat
    libsodium
    libxcrypt
    libstemmer
    cyrus_sasl.dev
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    systemd
    pam
    libcap
    inotify-tools
  ]
  ++ lib.optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isDarwin) libtirpc
  ++ lib.optional withApparmor libapparmor
  ++ lib.optional withLDAP openldap
  ++ lib.optional withPCRE2 pcre2
  ++ lib.optional withUnwind libunwind
  ++ lib.optional withMySQL libmysqlclient
  ++ lib.optional withPgSQL libpq
  ++ lib.optional withSQLite sqlite
  ++ lib.optional withLua lua5_3;

  src = fetchzip {
    url = "https://dovecot.org/releases/${lib.versions.majorMinor finalAttrs.version}/dovecot-${finalAttrs.version}.tar.gz";
    inherit hash;
  };

  enableParallelBuilding = true;

  postConfigure = lib.optionalString (lib.strings.versionAtLeast version "2.4") ''
    substituteInPlace src/lib-regex/Makefile --replace-fail \
      "test_regex_DEPENDENCIES = libdregex.la \$(LIBPCRE_LIBS)" \
      "test_regex_DEPENDENCIES = libdregex.la"
  '';

  postPatch = ''
    sed -i -E \
      -e 's!/bin/sh\b!${stdenv.shell}!g' \
      -e 's!([^[:alnum:]/_-])/bin/([[:alnum:]]+)\b!\1${coreutils}/bin/\2!g' \
      -e 's!([^[:alnum:]/_-])(head|sleep|cat)\b!\1${coreutils}/bin/\2!g' \
      src/lib-program-client/test-program-client-local.c

    patchShebangs src/lib-smtp/test-bin/*.sh
    sed -i -s -E 's!\bcat\b!${coreutils}/bin/cat!g' src/lib-smtp/test-bin/*.sh

    patchShebangs src/config/settings-get.pl
  ''
  + (
    let
      filePath =
        if lib.strings.versionAtLeast version "2.4" then
          "src/lib-auth/test-password-scheme.c"
        else
          "src/auth/test-libpassword.c";
    in
    ''
      # DES-encrypted passwords are not supported by Nixpkgs anymore
      sed '/test_password_scheme("CRYPT"/d' -i ${filePath}
    ''
  )
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    export systemdsystemunitdir=$out/etc/systemd/system
  '';

  # We need this for sysconfdir, see remark below.
  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
  '';

  patches =
    (patches fetchpatch)
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # fix timespec calls
      ./timespec.patch
    ];

  configureFlags = [
    # It will hardcode this for /var/lib/dovecot.
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
    "--localstatedir=/var"
    # We need this so utilities default to reading /etc/dovecot/dovecot.conf file.
    "--sysconfdir=/etc"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
    "--with-ssl=openssl"
    "--with-zlib"
    "--with-bzlib"
    "--with-lz4"
    "--with-lucene"
    "--with-icu"
    "--with-textcat"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "i_cv_epoll_works=${lib.boolToYesNo stdenv.hostPlatform.isLinux}"
    "i_cv_posix_fallocate_works=${lib.boolToYesNo stdenv.hostPlatform.isDarwin}"
    "i_cv_inotify_works=${lib.boolToYesNo stdenv.hostPlatform.isLinux}"
    "i_cv_signed_size_t=no"
    "i_cv_signed_time_t=yes"
    "i_cv_c99_vsnprintf=yes"
    "lib_cv_va_copy=yes"
    "i_cv_mmap_plays_with_write=yes"
    "i_cv_gmtime_max_time_t=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "i_cv_signed_time_t=yes"
    "i_cv_fd_passing=yes"
    "lib_cv_va_copy=yes"
    "lib_cv___va_copy=yes"
    "lib_cv_va_val_copy=yes"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--with-systemd"
  ++ lib.optional stdenv.hostPlatform.isDarwin "--enable-static"
  ++ lib.optional withLDAP "--with-ldap"
  ++ lib.optional withPCRE2 "--with-pcre2"
  ++ lib.optional withLua "--with-lua"
  ++ lib.optional withMySQL "--with-mysql"
  ++ lib.optional withPgSQL "--with-pgsql"
  ++ lib.optional withSQLite "--with-sqlite";

  doCheck = !stdenv.hostPlatform.isDarwin;

  strictDeps = true;

  meta = {
    homepage = "https://dovecot.org/";
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    license = with lib.licenses; [
      mit
      publicDomain
      lgpl21Only
      bsd3
      bsdOriginal
    ];
    mainProgram = "dovecot";
    maintainers = with lib.maintainers; [
      das_j
      fpletz
      helsinki-Jo
      jappie3
      prince213
    ];
    platforms = lib.platforms.unix;
  };
  passthru = {
    inherit dovecot_pigeonhole;
    tests = {
      opensmtpd-interaction = nixosTests.opensmtpd;
      inherit (nixosTests) dovecot;
    };
  };
})
