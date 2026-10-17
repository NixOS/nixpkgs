{
  lib,
  stdenv,
  cmake,
  boost,
  bison,
  flex,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
  symlinkJoin,
  gitMinimal,
  perl,
  python3,
  zlib,
  minisat,
  cryptominisat,
  gmp,
  cadical_2,
  gtest,
  lit,
  llvmPackages,
  outputcheck,
  nix-update-script,
  useCadical ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stp";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    tag = finalAttrs.version;
    hash = "sha256-rY5YE9VJz1YXf7W0BxVedZPMnlQ9wdcI2V0ta3WEV80=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/stp/stp/pull/704
    (fetchpatch {
      name = "python-3.14-ast-constant.patch";
      url = "https://github.com/stp/stp/commit/e5ab190e872d669b8fcd0d76e432e982707fa706.patch";
      hash = "sha256-EKeLny9sb2XVsJHzSDh2WVvIg8jPIr0MkEqCHvctbB8=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail GIT-hash-notfound "$version"

    # We want to use the Nix wrapper for the output check tool instead of running it through Python.
    substituteInPlace tests/query-files/lit.cfg \
      --replace-fail "pythonExec + ' ' +OutputCheckTool" "OutputCheckTool"

    # Results in duplication of Nix store paths and trouble finding the Python library at runtime
    substituteInPlace bindings/python/stp/library_path.py.in_install \
      --replace-fail "@CMAKE_INSTALL_PREFIX@/" ""
  ''
  + lib.optionalString useCadical ''
    # Fix up Cadical paths.
    substituteInPlace include/stp/Sat/Cadical.h \
      --replace-fail "src/cadical.hpp" "cadical.hpp"

    substituteInPlace CMakeLists.txt \
      --replace-fail \
      'find_path(CADICAL_INCLUDE_DIR NAMES src/cadical.hpp HINTS ''${CADICAL_DIR})' \
      'find_path(CADICAL_INCLUDE_DIR NAMES cadical.hpp HINTS ''${CADICAL_DIR}/include)' \
      --replace-fail "''${CADICAL_DIR}/build" "''${CADICAL_DIR}/lib"
  '';

  buildInputs = [
    boost
    zlib
    python3
    gmp
    minisat
  ]
  ++ lib.optional (!useCadical) cryptominisat;

  nativeBuildInputs = [
    cmake
    bison
    flex
    gitMinimal
    perl
    pkg-config
  ];

  cmakeFlags =
    let
      # STP expects Cadical dependencies to all be in the same place.
      cadicalDependency = symlinkJoin {
        name = "stp-${finalAttrs.version}-cadical";
        paths = [
          cadical_2.lib
          cadical_2.dev
        ];
      };
    in
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
      (lib.cmakeBool "USE_CADICAL" useCadical)
      (lib.cmakeBool "NOCRYPTOMINISAT" useCadical)
      (lib.cmakeBool "FORCE_CMS" (!useCadical))
      (lib.cmakeBool "ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
    ]
    ++ lib.optional finalAttrs.finalPackage.doCheck (lib.cmakeFeature "LIT_ARGS" "-v")
    ++ lib.optional useCadical (lib.cmakeFeature "CADICAL_DIR" (toString cadicalDependency));

  outputs = [
    "dev"
    "out"
  ];

  preConfigure = ''
    python_install_dir=$out/${python3.sitePackages}
    mkdir -p $python_install_dir
    cmakeFlagsArray+=(
      "-DPYTHON_LIB_INSTALL_DIR=$python_install_dir"
    )
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    # Link in gtest and the output check utility.
    mkdir -p deps
    ln -s ${gtest.src} deps/gtest
    ln -s ${outputcheck} deps/OutputCheck
  '';

  nativeCheckInputs = [
    gtest
    lit
    llvmPackages.llvm # for the `not` binary
    outputcheck
  ];

  doCheck = true;

  postInstall = ''
    # Clean up installed gtest/gmock files that shouldn't be there.
    shopt -s globstar nocaseglob
    rm -rf $out/**/*g{test,mock}*

    # Some of the gtest/gmock files were in the pkgconfig folders, which may now be empty.
    find $out/ -name pkgconfig -type d -empty -delete
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/stp --version | tee /dev/stderr | grep -F "STP version $version"

    # Run the examples from the docs: https://stp.readthedocs.io/en/latest/#python-usage
    for binary in stp stp_simple; do
      echo "(set-logic QF_BV) (assert (= (bvsdiv (_ bv3 2) (_ bv2 2)) (_ bv0 2))) (check-sat) (exit)" | tee /dev/stderr | $out/bin/$binary | grep "^sat$"
    done
    PYTHONPATH=$out/${python3.sitePackages} ${lib.getExe python3} -c \
      "import stp; s = stp.Solver(); a, b, c = s.bitvec('a', 32), s.bitvec('b', 32), s.bitvec('c', 32); s.add(a == 5); s.add(b == 6); s.add(a + b == c); assert s.check(); print(s.model())" >&2
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(2\\.3\\.[0-9]+)$"
      ];
    };
  };

  meta = {
    description = "Simple Theorem Prover";
    homepage = "https://stp.github.io/";
    maintainers = with lib.maintainers; [
      McSinyx
      numinit
    ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.mit;
  };
})
