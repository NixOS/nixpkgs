{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  llvmPackages_21,
  cling,
  gcc-unwrapped,
  libffi,
  libxml2,
  ncurses,
  zlib,
  zstd,

  # tests
  gtest,

  # Which interpreter backend to build against. CppInterOp can use either
  # clang-repl (from upstream LLVM/Clang) or Cling. They are mutually exclusive.
  backend ? "clang-repl", # "clang-repl" | "cling"
}:

let
  llvmPackages = llvmPackages_21;
  inherit (llvmPackages) stdenv;

  useCling = backend == "cling";
  llvm = llvmPackages.llvm;
  clang = llvmPackages.clang-unwrapped;

  # For the cling backend we build against the LLVM/Clang/Cling that ship inside
  # `cling` itself (its LLVM 20 fork), so the ABI matches libcling. The CMake
  # config packages (LLVM, Clang, Cling) all live under cling.unwrapped.
  clingRoot = cling.unwrapped;

  # The Clang resource dir and standard-library include flags the JIT interpreter
  # needs, since there is no system compiler to probe in the Nix sandbox. Both
  # this package's own tests and xeus-cpp (via passthru) feed these to CppInterOp
  # through CPPINTEROP_EXTRA_INTERPRETER_ARGS. The resource dir must match the
  # Clang that CppInterOp was built against: the cling fork for the cling backend,
  # upstream LLVM otherwise. -nostdinc(++) makes the search hermetic: only the
  # -isystem paths below are used, never any stray host include dirs.
  resourceDir =
    if useCling then
      "${clingRoot}/lib/clang/20"
    else
      "${lib.getLib clang}/lib/clang/${lib.versions.major llvm.version}";
  interpreterArgs = [
    "-nostdinc"
    "-nostdinc++"
    "-resource-dir"
    resourceDir
    "-isystem"
    "${resourceDir}/include"
    "-isystem"
    "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}"
    "-isystem"
    "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}/${stdenv.hostPlatform.config}"
    "-isystem"
    "${lib.getDev stdenv.cc.libc}/include"
  ];
in

assert lib.assertOneOf "backend" backend [
  "clang-repl"
  "cling"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "cpp-interop-${backend}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "compiler-research";
    repo = "CppInterOp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-am2WObER9dlNQU/VMTY2ScMe/w8c4N8m/DVyNwHiBnw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    libffi
    libxml2
    ncurses
    zlib
    zstd
  ]
  ++ (
    if useCling then
      [ clingRoot ]
    else
      [
        llvm
        clang
      ]
  );

  # Upstream's unittests/CMakeLists.txt only fetches GoogleTest over the network
  # (forbidden in the sandbox) when no gtest target exists; point it at the
  # nixpkgs gtest instead so the tests can build offline.
  postPatch = ''
    substituteInPlace unittests/CMakeLists.txt \
      --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "CPPINTEROP_USE_CLING" useCling)
    (lib.cmakeBool "CPPINTEROP_USE_REPL" (!useCling))
    (lib.cmakeBool "CPPINTEROP_ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
  ]
  ++ (
    if useCling then
      [
        "-DCling_DIR=${clingRoot}/lib/cmake/cling"
        "-DLLVM_DIR=${clingRoot}/lib/cmake/llvm"
        "-DClang_DIR=${clingRoot}/lib/cmake/clang"
      ]
    else
      [
        "-DLLVM_DIR=${llvm.dev}/lib/cmake/llvm"
        "-DClang_DIR=${clang.dev}/lib/cmake/clang"
      ]
  );

  # Run the upstream GoogleTest suite. Only the clang-repl backend is exercised;
  # the Cling backend skips many of these tests upstream.
  doCheck = !useCling;
  checkInputs = [ gtest ];
  checkPhase = ''
    runHook preCheck

    export CPPINTEROP_EXTRA_INTERPRETER_ARGS="${lib.concatStringsSep " " interpreterArgs}"
    # Upstream registers the tests only in the unittests subdir; its
    # check-cppinterop target builds them and runs ctest from the right place.
    ninja check-cppinterop

    runHook postCheck
  '';

  # Smoke test: drive the backend to JIT-compile and run a function, proving
  # the installed library, headers and runtime linking all work together.
  doInstallCheck = !useCling;
  installCheckPhase = ''
    runHook preInstallCheck

    cat > smoke.cpp <<'EOF'
    #include "CppInterOp/CppInterOp.h"
    #include <cstdio>
    int main() {
      Cpp::CreateInterpreter();
      if (Cpp::Declare("int square(int x) { return x * x; }") != 0) return 1;
      bool hadError = false;
      intptr_t result = Cpp::Evaluate("square(7)", &hadError);
      if (hadError) return 2;
      if (result != 49) { std::printf("expected 49, got %ld\n", (long)result); return 3; }
      if (Cpp::GetNamed("square") == nullptr) return 4;
      return 0;
    }
    EOF

    $CXX -std=c++17 smoke.cpp -I$out/include -L$out/lib -lclangCppInterOp -o smoke
    LD_LIBRARY_PATH=$out/lib ./smoke

    runHook postInstallCheck
  '';

  passthru = {
    inherit backend resourceDir interpreterArgs;
  };

  meta = {
    description = "Clang-based C++ interoperability library (${backend} backend)";
    homepage = "https://github.com/compiler-research/CppInterOp";
    changelog = "https://github.com/compiler-research/CppInterOp/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
  };
})
