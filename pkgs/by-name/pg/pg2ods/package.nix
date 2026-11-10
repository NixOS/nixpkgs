{
  lib,
  stdenv,
  idris2Packages,
  libpq,
  fetchFromGitea,
  zlib,
}:

let
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

    # Use absolute paths for the libraries named in %foreign.
    postPatch =
      let
        ext =
          if stdenv.hostPlatform.isDarwin then
            {
              pq = ".5.dylib";
              z = ".1.dylib";
            }
          else
            {
              pq = ".so.5";
              z = ".so.1";
            };
      in
      ''
        substituteInPlace src/Postgres.idr \
          --replace-fail libpq.so.5 ${lib.getLib libpq}/lib/libpq${ext.pq}
        substituteInPlace src/ZipWriter.idr \
          --replace-fail libz.so.1 ${lib.getLib zlib}/lib/libz${ext.z}
      '';

    # Run the self-test binary directly: the launcher script needs zsh
    # on macOS.
    doCheck = true;
    checkPhase = ''
      runHook preCheck
      export IDRIS2_PREFIX=$TMPDIR/idris2
      idris2 --install pg2ods.ipkg
      export IDRIS2_PACKAGE_PATH=$IDRIS2_PREFIX/idris2-${idris2Packages.idris2.version}:$IDRIS2_PACKAGE_PATH
      idris2 --build test/test.ipkg
      checkLibPath=${idris2Packages.idris2.libidris2_support}/lib
      LD_LIBRARY_PATH=$checkLibPath DYLD_LIBRARY_PATH=$checkLibPath \
        test/build/exec/pg2ods-test_app/pg2ods-test.so $TMPDIR/selftest.ods
      runHook postCheck
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
