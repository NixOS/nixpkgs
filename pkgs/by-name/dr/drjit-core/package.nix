{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, robin-map
, nanothread
, xxHash
, lz4
, llvmPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drjit-core";
  version = "unstable-2023-10-21";

  src = fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "drjit-core";
    rev = "d70987768138df1a09cbab86cbbe381a28d3d50a";
    hash = "sha256-GOqqMpKydFuizQ+GhDt1YXxK5aCM9O2yESRQN1BCKYg=";
    fetchSubmodules = true;
  };
  patches = [
    ./0001-CMakeLists.txt-find_package-by-default-fallback-to-t.patch
    ./0002-cmake-add-the-install-targets.patch
    ./0003-libdrjit-core-try-linking-libLLVM.so-directly.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    nanothread

    lz4
    robin-map
    xxHash

    llvmPackages.libllvm.dev

    stdenv.cc.cc.lib # libatomic...
  ];

  cmakeFlags = [
    (lib.cmakeBool "DRJIT_ENABLE_TESTS" (finalAttrs.doCheck))
  ];

  doCheck = true;

  # I don't know how but the `make test`/`make check` targets are broken
  checkPhase = ''
    runHook preCheck
    for test in ./tests/test_* ; do
      HOME=$TMPDIR "$test"
    done
    runHook postCheck
  '';

  meta = with lib; {
    description = "Dr.Jit — A Just-In-Time-Compiler for Differentiable Rendering (core library";
    homepage = "https://github.com/mitsuba-renderer/drjit-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "drjit-core";
    platforms = platforms.all;
  };
})
