{
  lib,
  stdenv,
  cmake,
  ninja,
  python3,
  lfortran,
}:

# Upstream's integration test suite: several thousand Fortran programs built
# and run with the LLVM backend.
stdenv.mkDerivation {
  name = "${lfortran.pname}-test-integration";
  inherit (lfortran) src;

  __structuredAttrs = true;

  # Tests known to fail per platform. Upstream CI doesn't cover aarch64-linux,
  # where mostly real(16)/long double tests crash.
  excludedTests = (lib.importJSON ./integration-excluded.json).${stdenv.hostPlatform.system} or [ ];

  # Drop each excluded test's RUN() call, which may span several lines, so it
  # is neither built nor run.
  postPatch = ''
    for test in "''${excludedTests[@]}"; do
      grep -q "^RUN(NAME $test[ )]" integration_tests/CMakeLists.txt \
        || { echo "excluded test $test not found" >&2; exit 1; }
      sed -i "/^RUN(NAME $test[ )]/{:a;/)/!{N;ba;};d;}" integration_tests/CMakeLists.txt
    done
  '';

  nativeBuildInputs = [
    lfortran
    cmake
    ninja
    python3
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cd integration_tests
    patchShebangs .
    python run_tests.py -b llvm --ninja -j $NIX_BUILD_CORES \
      --build-dir "$TMPDIR/build" --compiler-dir ${lfortran}/bin

    runHook postBuild
  '';

  installPhase = ''
    touch $out
  '';

  requiredSystemFeatures = [ "big-parallel" ];
}
