{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, llvm_17
, curl
, tzdata
, libconfig
, lit
, gdb
, unzip
, darwin
, bash
, callPackage
, makeWrapper
, runCommand
, targetPackages

, ldcBootstrap ? callPackage ./bootstrap.nix { }
}:

let
  pathConfig = runCommand "ldc-lib-paths" {} ''
    mkdir $out
    echo ${tzdata}/share/zoneinfo/ > $out/TZDatabaseDirFile
    echo ${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > $out/LibcurlPathFile
  '';

in

stdenv.mkDerivation (finalAttrs: {
  pname = "ldc";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "ldc-developers";
    repo = "ldc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d/UREh+fHRRh0r3H60uPjHute+qspcm9TBFWZMbGDxk=";
    fetchSubmodules = true;
  };

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  postPatch = ''
    patchShebangs runtime tools tests

    rm tests/dmd/fail_compilation/mixin_gc.d
    rm tests/dmd/runnable/xtest46_gc.d
    rm tests/dmd/runnable/testptrref_gc.d

    # test depends on current year
    rm tests/dmd/compilable/ddocYear.d
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace runtime/phobos/std/socket.d --replace-fail "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace runtime/phobos/std/socket.d --replace-fail "foreach (name; names)" "names = []; foreach (name; names)"

    # https://github.com/NixOS/nixpkgs/issues/34817
    rm -r tests/plugins/addFuncEntryCall
  '';

  nativeBuildInputs = [
    cmake ldcBootstrap lit lit.python llvm_17.dev makeWrapper ninja unzip
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # https://github.com/NixOS/nixpkgs/pull/36378#issuecomment-385034818
    gdb
  ];

  buildInputs = [ curl tzdata ];

  cmakeFlags = [
    "-DD_FLAGS=-d-version=TZDatabaseDir;-d-version=LibcurlPath;-J${pathConfig}"
  ];

  postConfigure = ''
    export DMD=$PWD/bin/ldmd2
  '';

  makeFlags = [ "DMD=$DMD" ];

  fixNames = lib.optionalString stdenv.hostPlatform.isDarwin ''
    fixDarwinDylibNames() {
      local flags=()

      for fn in "$@"; do
        flags+=(-change "$(basename "$fn")" "$fn")
      done

      for fn in "$@"; do
        if [ -L "$fn" ]; then continue; fi
        echo "$fn: fixing dylib"
        install_name_tool -id "$fn" "''${flags[@]}" "$fn"
      done
    }

    fixDarwinDylibNames $(find "$(pwd)/lib" -name "*.dylib")
    export DYLD_LIBRARY_PATH=$(pwd)/lib
  '';

  # https://github.com/ldc-developers/ldc/issues/2497#issuecomment-459633746
  additionalExceptions = lib.optionalString stdenv.hostPlatform.isDarwin
    "|druntime-test-shared";

  checkPhase = ''
    # Build default lib test runners
    ninja -j$NIX_BUILD_CORES all-test-runners

    ${finalAttrs.fixNames}

    # Run dmd testsuite
    export DMD_TESTSUITE_MAKE_ARGS="-j$NIX_BUILD_CORES DMD=$DMD"
    ctest -V -R "dmd-testsuite"

    # Build and run LDC D unittests.
    ctest --output-on-failure -R "ldc2-unittest"

    # Run LIT testsuite.
    ctest -V -R "lit-tests"

    # Run default lib unittests
    ctest -j$NIX_BUILD_CORES --output-on-failure -E "ldc2-unittest|lit-tests|dmd-testsuite${finalAttrs.additionalExceptions}"
  '';

  postInstall = ''
    wrapProgram $out/bin/ldc2 \
      --prefix PATH : ${targetPackages.stdenv.cc}/bin \
      --set-default CC ${targetPackages.stdenv.cc}/bin/cc
  '';

  meta = with lib; {
    description = "LLVM-based D compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    changelog = "https://github.com/ldc-developers/ldc/releases/tag/v${finalAttrs.version}";
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with licenses; [ bsd3 boost mit ncsa gpl2Plus ];
    mainProgram = "ldc2";
    maintainers = with maintainers; [ lionello jtbx ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
