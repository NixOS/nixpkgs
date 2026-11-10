{
  lib,
  stdenv,
  idris2Packages,
  libpq,
  fetchFromGitea,
  zlib,
}:

let
  libraryPath = lib.makeLibraryPath [
    libpq
    zlib
  ];

  pkg = idris2Packages.buildIdris rec {
    ipkgName = "pg2ods";
    version = "0.3.0";

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "klt";
      repo = "pg2ods";
      tag = version;
      hash = "sha256-dwBa1OvfmfAAaRCGzX0yd7NsywTuTIoGqF4wgl/4Osg=";
    };

    strictDeps = true;
    __structuredAttrs = true;

    idrisLibraries = [ ];

    # The Chez Scheme build loads libpq and libz at run time (dlopen);
    # wrapProgram below puts them on the library path.
    buildInputs = [
      libpq
      zlib
    ];

    # The %foreign declarations name the Linux libraries (libpq.so.5,
    # libz.so.1). On macOS the same libraries are called
    # libpq.5.dylib and libz.1.dylib.
    postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/Postgres.idr \
        --replace-fail libpq.so.5 libpq.5.dylib
      substituteInPlace src/ZipWriter.idr \
        --replace-fail libz.so.1 libz.1.dylib
    '';

    # The self-test (test/test.ipkg) needs no database. It depends on
    # the pg2ods library, which is installed into a temporary prefix.
    # LD_LIBRARY_PATH is used on Linux, DYLD_LIBRARY_PATH on macOS.
    # The test program is started directly, not through the launcher
    # script Idris writes: on macOS that script needs zsh, which the
    # Nix build does not have. buildIdris does the same for pg2ods.
    doCheck = true;
    checkPhase = ''
      runHook preCheck
      export IDRIS2_PREFIX=$TMPDIR/idris2
      idris2 --install pg2ods.ipkg
      export IDRIS2_PACKAGE_PATH=$IDRIS2_PREFIX/idris2-${idris2Packages.idris2.version}:$IDRIS2_PACKAGE_PATH
      idris2 --build test/test.ipkg
      checkLibPath=${libraryPath}:${idris2Packages.idris2.libidris2_support}/lib
      LD_LIBRARY_PATH=$checkLibPath DYLD_LIBRARY_PATH=$checkLibPath \
        test/build/exec/pg2ods-test_app/pg2ods-test.so $TMPDIR/selftest.ods
      runHook postCheck
    '';

    postInstall = ''
      wrapProgram $out/bin/pg2ods \
        --prefix LD_LIBRARY_PATH : ${libraryPath} \
        --prefix DYLD_LIBRARY_PATH : ${libraryPath}
    '';

    meta = {
      description = "Export PostgreSQL tables, views or queries to .ods";
      homepage = "https://codeberg.org/klt/pg2ods";
      license = lib.licenses.gpl3Plus;
      mainProgram = "pg2ods";
      maintainers = with lib.maintainers; [ kaelte ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
in
pkg.executable
