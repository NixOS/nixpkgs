{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  tcl,
  buildPackages,
  readline,
  ncurses,
  zlib,
  sqlite,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlcipher";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Qt7nOB0iMyNXfENC3gv3F6sENU7OUTZ3n2mo0M2CSA=";
  };

  nativeBuildInputs = [
    tcl
    util-linux
  ];

  buildInputs = [
    readline
    ncurses
    openssl
    zlib
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  configureFlags = [
    "--enable-threadsafe"
    "--with-readline-inc=-I${lib.getDev readline}/include"
    "--enable-load-extension"
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      # We want feature parity with sqlite
      sqlite.NIX_CFLAGS_COMPILE
      "-DSQLITE_HAS_CODEC"
      "-DSQLITE_EXTRA_INIT=sqlcipher_extra_init"
      "-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown"
      "-DSQLITE_TEMP_STORE=3"
    ];
    LDFLAGS = toString [
      "-lssl"
      "-lcrypto"
    ];
    BUILD_CC = "$(CC_FOR_BUILD)";
    TCLLIBDIR = "${placeholder "out"}/lib/tcl${lib.versions.majorMinor tcl.version}";
  };

  # Rename files from sqlite3 to sqlcipher to prevent file collisons
  postInstall = ''
    mv $out/bin/{sqlite3,sqlcipher}
    mkdir $out/include/sqlcipher
    mv $out/include/sqlite3.h $out/include/sqlcipher/sqlite3.h
    mv $out/include/sqlite3ext.h $out/include/sqlcipher/sqlite3ext.h
    mv $out/lib/lib{sqlite3,sqlcipher}.a
    rm -f $out/lib/libsqlite3.0.dylib $out/lib/libsqlite3.dylib $out/lib/libsqlite3.so $out/lib/libsqlite3.so.0
    rename libsqlite3 libsqlcipher $out/lib/libsqlite3*
    mv $out/lib/pkgconfig/{sqlite3,sqlcipher}.pc
    mv $out/share/man/man1/{sqlite3,sqlcipher}.1
    substituteInPlace $out/lib/pkgconfig/sqlcipher.pc \
      --replace-fail "-lsqlite3" "-lsqlcipher" \
      --replace-fail "-lz" "-lz -lcrypto" \
      --replace-fail "includedir}" "includedir}/sqlcipher"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    f=$(echo $out/lib/libsqlcipher.*.dylib)
    ln --symbolic --force "$f" $out/lib/libsqlcipher.0.dylib
    ln --symbolic --force "$f" $out/lib/libsqlcipher.dylib
    ln --symbolic --force "$f" $out/lib/libsqlite3.dylib
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    f=$(echo $out/lib/libsqlcipher.so.*)
    ln --symbolic --force "$f" $out/lib/libsqlcipher.so.0
    ln --symbolic --force "$f" $out/lib/libsqlcipher.so
  '';

  meta = {
    changelog = "https://github.com/sqlcipher/sqlcipher/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "SQLite extension that provides 256 bit AES encryption of database files";
    mainProgram = "sqlcipher";
    homepage = "https://www.zetetic.net/sqlcipher/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
