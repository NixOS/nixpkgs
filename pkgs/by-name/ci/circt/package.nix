{
  stdenv,
  lib,
  cmake,
  coreutils,
  python3,
  git,
  fetchFromGitHub,
  ninja,
  lit,
  z3,
  gitUpdater,
  callPackage,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.psutil ]);
  circt-llvm = callPackage ./circt-llvm.nix { };
in
stdenv.mkDerivation rec {
  pname = "circt";
  version = "1.99.1";
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "circt";
    rev = "firtool-${version}";
    hash = "sha256-pnC8BLf2encv7UR10q6rTTpAZ6T0fETwumwTSu+Q8Ro=";
    fetchSubmodules = true;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  nativeBuildInputs = [
    cmake
    ninja
    git
    pythonEnv
    z3
  ];
  buildInputs = [ circt-llvm ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMLIR_DIR=${circt-llvm.dev}/lib/cmake/mlir"

    # LLVM_EXTERNAL_LIT is executed by python3, the wrapped bash script will not work
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/.lit-wrapped"
    "-DCIRCT_LLHD_SIM_ENABLED=OFF"
  ];

  # cannot use lib.optionalString as it creates an empty string, disabling all tests
  LIT_FILTER_OUT =
    let
      lit-filters =
        # There are some tests depending on `clang-tools` to work. They are activated only when detected
        # `clang-tidy` in PATH, However, we cannot simply put `clang-tools` in checkInputs to make these
        # tests work. Because
        #
        # 1. The absolute paths of binaries used in tests are resolved in configure phase.
        # 2. When stdenv = clangStdenv, the `clang-tidy` binary appears in PATH via `clang-unwrapped`,
        #    which is always placed before `${clang-tools}/bin` in PATH. `clang-tidy` provided in
        #    `clang-unwrapped` cause tests failing because it is not wrapped to resolve header search paths.
        #    https://github.com/NixOS/nixpkgs/issues/214945 discusses this issue.
        #
        # As a temporary fix, we disabled these tests when using clang stdenv
        lib.optionals stdenv.cc.isClang [ "CIRCT :: Target/ExportSystemC/.*\\.mlir" ]
        # Disable some tests on x86_64-darwin
        ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
          # These test seem to pass on hydra (rosetta) but not on x86_64-darwin machines
          "CIRCT :: Target/ExportSMTLIB/.*\\.mlir"
          "CIRCT :: circt-bmc/.*\\.mlir"
          # These tests were having issues on rosetta
          "CIRCT :: Dialect/.*/Reduction/.*\\.mlir"
          "CIRCT :: Dialect/SMT/.*\\.mlir"
          "CIRCT :: circt-as-dis/.*\\.mlir"
          "CIRCT :: circt-reduce/.*\\.mlir"
          "CIRCT :: circt-test/basic.mlir"
        ]
        ++ [
          # Temporarily disable for bump: https://github.com/llvm/circt/issues/8000
          "CIRCT :: Dialect/FIRRTL/SFCTests/ExtractSeqMems/Compose.fir"
          "CIRCT :: Dialect/FIRRTL/SFCTests/ExtractSeqMems/Simple2.fir"
          "CIRCT :: Dialect/FIRRTL/extract-instances.mlir"
        ];
    in
    if lit-filters != [ ] then lib.strings.concatStringsSep "|" lit-filters else null;

  postPatch = ''
    patchShebangs tools/circt-test
  '';

  preConfigure = ''
    find ./test -name '*.mlir' -exec sed -i 's|/usr/bin/env|${coreutils}/bin/env|g' {} \;
    # circt uses git to check its version, but when cloned on nix it can't access git.
    # So this hard codes the version.
    substituteInPlace cmake/modules/GenVersionFile.cmake \
      --replace-fail "unknown git version" "${src.rev}"
    # Increase timeout on tests because some were failing on hydra.
    # Using `replace-warn` so it doesn't break when upstream changes the timeout.
    substituteInPlace integration_test/CMakeLists.txt \
      --replace-warn 'set(CIRCT_INTEGRATION_TIMEOUT 60)' 'set(CIRCT_INTEGRATION_TIMEOUT 300)'
  '';

  doCheck = true;
  checkTarget = "check-circt check-circt-integration";

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    echo moving libarc-jit-env.dylib to '$lib' before check because archilator links to the output path
    mkdir -pv $lib/lib
    cp -v ./lib/libarc-jit-env.dylib $lib/lib
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  # Copy circt-llvm's postFixup stage so that it can make all our dylib references
  # absolute as well.
  #
  # We don't need `postPatch` because circt seems to be automatically inheriting
  # the config somehow, presumably via. `-DMLIR_DIR`.
  postFixup = circt-llvm.postFixup;

  postInstall = ''
    moveToOutput lib "$lib"
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "firtool-";
    };
    llvm = circt-llvm;
  };

  meta = {
    description = "Circuit IR compilers and tools";
    homepage = "https://circt.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sharzy
      pineapplehunter
      sequencer
    ];
    platforms = lib.platforms.all;
  };
}
