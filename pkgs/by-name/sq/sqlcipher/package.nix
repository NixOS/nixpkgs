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
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3iIr6wCVT+74VREreL2wHttNG8KXJSyqJtoveJSgIc=";
  };

  nativeBuildInputs = [
    tcl
    util-linux
  ];

  buildInputs = [
    ncurses
    openssl
    zlib
  ]
  # readline's interactive CLI depends on terminal APIs unavailable on iOS.
  ++ lib.optionals (!stdenv.hostPlatform.isiOS) [ readline ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  # autosetup/ uses an autosetup- prefix, outside the default
  # updateAutotoolsGnuConfigScriptsHook glob — refresh manually for new triples.
  postPatch = ''
    for script in config.sub config.guess; do
      if [ -f "autosetup/autosetup-$script" ]; then
        cp -f "${buildPackages.gnu-config}/$script" "autosetup/autosetup-$script"
      fi
    done
  '';

  configureFlags = [
    "--enable-threadsafe"
    "--enable-load-extension"
    (
      if stdenv.hostPlatform.isiOS then
        "--disable-readline"
      else
        "--with-readline-inc=-I${lib.getDev readline}/include"
    )
  ]
  # Tcl needs to be runnable at build time; disable when build can't exec host.
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ "--disable-tcl" ];

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        # We want feature parity with sqlite
        sqlite.NIX_CFLAGS_COMPILE
        "-DSQLITE_HAS_CODEC"
        "-DSQLITE_EXTRA_INIT=sqlcipher_extra_init"
        "-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown"
        "-DSQLITE_TEMP_STORE=3"
      ]
      # iOS forbids system(3); sqlite's upstream knob compiles out every call
      # site plus the .edit/.shell/.system/xdg-open CLI features that use them.
      ++ lib.optional stdenv.hostPlatform.isiOS "-DSQLITE_NOHAVE_SYSTEM"
    );
    LDFLAGS = toString [
      "-lssl"
      "-lcrypto"
    ];
    BUILD_CC = "$(CC_FOR_BUILD)";
  }
  // lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
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
    find $out/lib -maxdepth 1 -type l -name 'libsqlite3*' -delete
    rename libsqlite3 libsqlcipher $out/lib/libsqlite3*
    mv $out/lib/pkgconfig/{sqlite3,sqlcipher}.pc
    mv $out/share/man/man1/{sqlite3,sqlcipher}.1
    substituteInPlace $out/lib/pkgconfig/sqlcipher.pc \
      --replace-fail "-lsqlite3" "-lsqlcipher" \
      --replace-fail "-lz" "-lz -lcrypto" \
      --replace-fail "includedir}" "includedir}/sqlcipher"
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isiOS) ''
    f=$(echo $out/lib/libsqlcipher.*.dylib)
    ln --symbolic --force "$f" $out/lib/libsqlcipher.0.dylib
    ln --symbolic --force "$f" $out/lib/libsqlcipher.dylib
    ln --symbolic --force "$f" $out/lib/libsqlite3.dylib
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    f=$(echo $out/lib/libsqlcipher.so.*)
    ln --symbolic --force "$f" $out/lib/libsqlcipher.so.0
    ln --symbolic --force "$f" $out/lib/libsqlcipher.so
  ''
  + lib.optionalString stdenv.hostPlatform.isiOS ''
    # iOS ships the versioned .so as libsqlcipher.<version>.so (no .so.<version>).
    f=$(echo $out/lib/libsqlcipher.*.so)
    ln -sf "$f" $out/lib/libsqlcipher.0.so
    ln -sf "$f" $out/lib/libsqlcipher.so
    ln -sf "$f" $out/lib/libsqlite3.so
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
