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
  perl,
  python3,
  zlib,
  minisat,
  cryptominisat,
  gmp,
  cadical,
  gtest,
  lit,
  outputcheck,
  nix-update-script,
  useCadical ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stp";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    tag = "${finalAttrs.version}_cadical";
    hash = "sha256-fNx3/VS2bimlVwCejEZtNGDqVKnwBm0O2YkIUQm6eDM=";
  };
  patches = [
    # Python 3.12+ compatibility for build: https://github.com/stp/stp/pull/450
    (fetchpatch {
      url = "https://github.com/stp/stp/commit/fb185479e760b6ff163512cb6c30ac9561aadc0e.patch";
      hash = "sha256-guFgeWOrxRrxkU7kMvd5+nmML0rwLYW196m1usE2qiA=";
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
      --replace-fail "build/libcadical.a" "lib/libcadical.a" \
      --replace-fail 'include_directories(''${CADICAL_DIR}/)' 'include_directories(''${CADICAL_DIR}/include)'
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
    perl
    pkg-config
  ];

  cmakeFlags =
    let
      # STP expects Cadical dependencies to all be in the same place.
      cadicalDependency = symlinkJoin {
        name = "stp-${finalAttrs.version}-cadical";
        paths = [
          cadical.lib
          cadical.dev
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

  # Fixes the following warning in the aarch64 build on Linux:
  # lib/extlib-abc/aig/cnf/cnfData.c:4591:25: warning: result of comparison of
  # constant 255 with expression of type 'signed char' is always false [-Wtautological-constant-out-of-range-compare]
  # 4591 |         if ( pMemory[k] == (char)(-1) )
  #
  # This seems to cause an infinite loop in tests on aarch64-linux platforms.
  #
  # TODO: Remove these CFLAGS when they update to the version that pulls `abc` in with a submodule.
  # https://github.com/stp/stp/issues/498#issuecomment-2611251631
  CFLAGS = [ "-fsigned-char" ];

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
    outputcheck
  ];

  doCheck = true;

  postInstall = ''
    # Clean up installed gtest/gmock files that shouldn't be there.
    shopt -s globstar nocaseglob
    rm -rf $out/**/*g{test,mock}*

    # Some of the gtest/gmock files were in the pkgconfig folders, which may now be empty.
    find $out/ -name pkgconfig -type d -empty -delete

    # Python bindings are broken:
    substituteInPlace $python_install_dir/**/stp.py \
      --replace-fail "from library_path import PATHS" "from .library_path import PATHS"
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
