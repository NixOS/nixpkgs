{ stdenv
, fetchFromGitHub
, bison
, cmake
, makeWrapper
, ninja
, nodejs
, npmHooks
, pkg-config
, blas
, boehmgc
, boost
, eigen
, fflas-ffpack
, flint
, frobby
, gdbm
, givaro
, gmp
, libatomic_ops
, libffi
, libxml2
, mpfi
, mpfr
, mpsolve
, ntl
, readline
, singular
, tbb
, texlive
, fetchNpmDeps
, lib
, _4ti2
, cohomcalg
, csdp
, gfan
, nauty
, normaliz
, topcom
, which
}: stdenv.mkDerivation (final: {
  pname = "M2";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2";
    rev = "release-${final.version}";
    fetchSubmodules = true;
    hash = "sha256-jsueoBtM83wfp+YXSS9xY8MRhYxFp4+Ja6lcFcbR5SQ=";
  };
  patches = [
    ./quadmath.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    bison
    cmake
    makeWrapper
    ninja
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];
  buildInputs = [
    blas
    boehmgc
    boost
    eigen
    fflas-ffpack
    flint
    frobby
    gdbm
    givaro
    gmp
    libatomic_ops
    libffi
    libxml2
    mpfi
    mpfr
    mpsolve
    ntl
    readline
    singular
    tbb
    texlive.combined.scheme-small
  ];

  # The build system runs npm in the build directory, but npmConfigureHooks runs in the unpacked source.
  # Make the environment there similar enough to the build directory so that it works as expected.
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
    ln -s M2/Macaulay2 .
  '';

  npmDeps = fetchNpmDeps {
    src = ./.;
    hash = "sha256-Z0qaVmz/nLtH94k/iFI0IqC1BbNKw/bFPyvTURJw3ks=";
  };

  cmakeDir = "../M2";
  cmakeFlags = [
    # -march=native may be a good idea for local builds, but for distribution it's not.
    "-DBUILD_NATIVE=OFF"
    # Some code does not expect absolute paths here.
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_DOCDIR=share/doc/Macaulay2"
    "-DCMAKE_INSTALL_INFODIR=share/info"
    "-DCMAKE_INSTALL_MANDIR=share/man"
    # Circumvent hardcoded FHS paths.
    "-DREADLINE_ROOT_DIR=${readline.dev}"
    # ninja is not auto-detected due to the custom build phase.
    "-GNinja"
  ];

  # Since npm is run in the build directory, move the nodejs stuff there.
  preBuild = ''
    mv ../package.json ../package-lock.json ../node_modules .
    chmod +w package-lock.json
  '';

  buildPhase = ''
    runHook preBuild

    ninja -j''${NIX_BUILD_CORES-1}

    # The wrapper created by the build system is insufficient, replace it by our own.
    # Since install-packages calls the staged M2, we create a temporary wrapper pointing to the staging directory.
    STAGING_BIN="$(realpath "usr-dist/$(sed -n -e 's/^M2_EXEC_INFIX:INTERNAL=//p' CMakeCache.txt)/bin")"
    WRAPPER_FLAGS=(--prefix PATH : ${lib.makeBinPath [
      _4ti2
      cohomcalg
      csdp
      gfan
      nauty
      normaliz
      topcom
      which
    ]} --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
      mpfr
      mpsolve
    ]})
    rm "$STAGING_BIN/M2"
    makeWrapper "$STAGING_BIN/M2-binary" "$STAGING_BIN/M2" "''${WRAPPER_FLAGS[@]}"

    # Unlike the name might suggest, this actually "installs" the packages to the build directory only.
    ninja -j''${NIX_BUILD_CORES-1} install-packages

    runHook postBuild
  '';

  # Recreate the wrapper, this time referencing the final installed binary.
  postInstall = ''
    rm $out/bin/M2
    makeWrapper "$out/bin/M2-binary" "$out/bin/M2" "''${WRAPPER_FLAGS[@]}"
  '';

  meta = with lib; {
    description = "A software system for research in algebraic geometry";
    homepage = "https://macaulay2.com/";
    # Source is GPL2 or GPL3, but binaries are the latter only.
    license = with licenses; [ gpl3Only ];
    mainProgram = "M2";
    maintainers = with maintainers; [ alois31 ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
