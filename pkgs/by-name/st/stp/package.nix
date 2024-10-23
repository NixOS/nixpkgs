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
  useCadical ? true,
}:

stdenv.mkDerivation rec {
  pname = "stp";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    rev = "${version}_cadical";
    hash = "sha256-fNx3/VS2bimlVwCejEZtNGDqVKnwBm0O2YkIUQm6eDM=";
  };
  patches = [
    # Fix missing type declaration
    # due to undeterminisitic compilation
    # of circularly dependent headers
    ./stdint.patch

    # Python 3.12+ compatibility for build: https://github.com/stp/stp/pull/450
    (fetchpatch {
      url = "https://github.com/stp/stp/commit/fb185479e760b6ff163512cb6c30ac9561aadc0e.patch";
      hash = "sha256-guFgeWOrxRrxkU7kMvd5+nmML0rwLYW196m1usE2qiA=";
    })
  ];
  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail GIT-hash-notfound ${version}

      # We want to use the Nix wrapper for the output check tool instead of running it through Python.
      substituteInPlace tests/query-files/lit.cfg \
        --replace-fail "pythonExec + ' ' +OutputCheckTool" "OutputCheckTool"
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
  ] ++ lib.optional (!useCadical) cryptominisat;

  nativeBuildInputs = [
    cmake
    bison
    flex
    perl
    pkg-config
    gtest
    lit
  ];

  cmakeFlags =
    let
      onOff = var: flag: lib.singleton "-D${var}=${if flag then "ON" else "OFF"}";
    in
    onOff "BUILD_SHARED_LIBS" true
    ++ onOff "ENABLE_TESTING" true
    ++ lib.singleton "-DLIT_ARGS=-v"
    ++ onOff "USE_CADICAL" useCadical
    ++ onOff "NOCRYPTOMINISAT" useCadical
    ++ onOff "FORCE_CMS" (!useCadical)
    ++ lib.optional useCadical "-DCADICAL_DIR=${
      # STP expects Cadical dependencies to all be in the same place.
      symlinkJoin {
        name = "stp-cadical-deps";
        paths = [
          cadical.lib
          cadical.dev
        ];
      }
    }";

  preConfigure = ''
    python_install_dir=$out/${python3.sitePackages}
    mkdir -p $python_install_dir
    cmakeFlagsArray+=(
      "-DPYTHON_LIB_INSTALL_DIR=$python_install_dir"
    )

    # Link in gtest and the output check utility.
    mkdir -p deps
    ln -s ${gtest.src} deps/gtest
    ln -s ${outputcheck} deps/OutputCheck
  '';
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
    $out/bin/stp --version | grep '^STP version ${version}'
  '';

  meta = with lib; {
    description = "Simple Theorem Prover";
    homepage = "https://stp.github.io/";
    maintainers = with maintainers; [
      McSinyx
      numinit
    ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
