{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  # build
  cmake,
  ctags,
  python3Packages,
  swig,
  # math
  eigen,
  blas,
  lapack,
  glpk,
  # data
  protobuf,
  json_c,
  libxml2,
  hdf5,
  curl,
  # compression
  libarchive,
  bzip2,
  xz,
  snappy,
  lzo,
  # more math
  nlopt,
  lp_solve,
  colpack,
  # extra support
  pythonSupport ? false,
  opencvSupport ? false,
  opencv ? null,
  withSvmLight ? false,
}:

assert pythonSupport -> python3Packages != null;
assert opencvSupport -> opencv != null;

assert (!blas.isILP64) && (!lapack.isILP64);

let
  pname = "shogun";
  version = "6.1.4";

  rxcppVersion = "4.0.0";
  gtestVersion = "1.8.0";

  srcs = {
    toolbox = fetchFromGitHub {
      owner = "shogun-toolbox";
      repo = "shogun";
      rev = "shogun_${version}";
      hash = "sha256-38aULxK50wQ2+/ERosSpRyBmssmYSGv5aaWfWSlrSRc=";
      fetchSubmodules = true;
    };

    # The CMake external projects expect the packed archives
    rxcpp = fetchurl {
      url = "https://github.com/Reactive-Extensions/RxCpp/archive/v${rxcppVersion}.tar.gz";
      sha256 = "sha256-UOc5WrG8KgAA3xJsaSCjbdPE7gSnFJay9MEK31DWUXg=";
    };

    gtest = fetchurl {
      url = "https://github.com/google/googletest/archive/release-${gtestVersion}.tar.gz";
      sha256 = "sha256-WKb0J3yivIVlIis7vVihd2CenEiOinJkk1m6UUUNt9g=";
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = srcs.toolbox;

  patches = [
    # Fix compile errors with GCC 9+
    # https://github.com/shogun-toolbox/shogun/pull/4811
    (fetchpatch {
      url = "https://github.com/shogun-toolbox/shogun/commit/c8b670be4790e0f06804b048a6f3d77c17c3ee95.patch";
      sha256 = "sha256-MxsR3Y2noFQevfqWK3nmX5iK4OVWeKBl5tfeDNgjcXk=";
    })
    (fetchpatch {
      url = "https://github.com/shogun-toolbox/shogun/commit/5aceefd9fb0e2132c354b9a0c0ceb9160cc9b2f7.patch";
      sha256 = "sha256-AgJJKQA8vc5oKaTQDqMdwBR4hT4sn9+uW0jLe7GteJw=";
    })

    # Fix virtual destruction
    (fetchpatch {
      url = "https://github.com/shogun-toolbox/shogun/commit/ef0e4dc1cc4a33c9e6b17a108fa38a436de2d7ee.patch";
      sha256 = "sha256-a9Rm0ytqkSAgC3dguv8m3SwOSipb+VByBHHdmV0d63w=";
    })
    ./fix-virtual-destruction.patch

    # Fix compile errors with json-c
    # https://github.com/shogun-toolbox/shogun/pull/4104
    (fetchpatch {
      url = "https://github.com/shogun-toolbox/shogun/commit/365ce4c4c700736d2eec8ba6c975327a5ac2cd9b.patch";
      sha256 = "sha256-OhEWwrHtD/sOcjHmPY/C9zJ8ruww8yXrRcTw38nGEJU=";
    })

    # Fix compile errors with Eigen 3.4
    ./eigen-3.4.patch

  ]
  ++ lib.optional (!withSvmLight) ./svmlight-scrubber.patch;

  nativeBuildInputs = [
    cmake
    swig
    ctags
  ]
  ++ (with python3Packages; [
    python
    jinja2
    ply
  ]);

  buildInputs = [
    eigen
    blas
    lapack
    glpk
    protobuf
    json_c
    libxml2
    hdf5
    curl
    libarchive
    bzip2
    xz
    snappy
    lzo
    nlopt
    lp_solve
    colpack
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      python
      numpy
    ]
  )
  ++ lib.optional opencvSupport opencv;

  cmakeFlags =
    let
      excludeTestsRegex = lib.concatStringsSep "|" [
        # segfault
        "SerializationXML"
        "TrainedModelSerialization"
        # broken by openblas 0.3.21
        "mathematics_lapack"
        # fails on aarch64
        "LinearTimeMMD"
        "QuadraticTimeMMD"
        "SGVectorTest"
        "Statistics"
        # hangs on aarch64
        "PRange"
        # these take too long on CI
        "evaluation_cross_validation"
        "modelselection_combined_kernel"
        "modelselection_grid_search"
      ];
    in
    [
      (lib.cmakeBool "BUILD_META_EXAMPLES" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_ARPACK" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_ARPREC" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_CPLEX" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_Mosek" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_TFLogger" true)
      (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_ViennaCL" true)
      (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'${excludeTestsRegex}'")
      (lib.cmakeBool "ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
      (lib.cmakeBool "DISABLE_META_INTEGRATION_TESTS" true)
      (lib.cmakeBool "TRAVIS_DISABLE_META_CPP" true)
      (lib.cmakeBool "INTERFACE_PYTHON" pythonSupport)
      (lib.cmakeBool "OpenCV" opencvSupport)
      (lib.cmakeBool "USE_SVMLIGHT" withSvmLight)
    ];

  CXXFLAGS = "-faligned-new";

  doCheck = true;

  postUnpack = ''
    mkdir -p $sourceRoot/third_party/{rxcpp,GoogleMock}
    ln -s ${srcs.rxcpp} $sourceRoot/third_party/rxcpp/v${rxcppVersion}.tar.gz
    ln -s ${srcs.gtest} $sourceRoot/third_party/GoogleMock/release-${gtestVersion}.tar.gz
  '';

  postPatch = ''
    # Fix preprocessing SVMlight code
    sed -i \
        -e 's@#ifdef SVMLIGHT@#ifdef USE_SVMLIGHT@' \
        -e '/^#ifdef USE_SVMLIGHT/,/^#endif/ s@#endif@#endif //USE_SVMLIGHT@' \
        src/shogun/kernel/string/CommUlongStringKernel.cpp
    sed -i -e 's/#if USE_SVMLIGHT/#ifdef USE_SVMLIGHT/' src/interfaces/swig/Machine.i
    sed -i -e 's@// USE_SVMLIGHT@//USE_SVMLIGHT@' src/interfaces/swig/Transfer.i
    sed -i -e 's@/\* USE_SVMLIGHT \*/@//USE_SVMLIGHT@' src/interfaces/swig/Transfer_includes.i

    # Fix build with CMake 4
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.5)"

    # Patch rxcpp to build with CMake 4 and GCC 14
    rxcpp_tmpdir=$(mktemp -d)
    tar -xzf third_party/rxcpp/v${rxcppVersion}.tar.gz -C "$rxcpp_tmpdir"
    rm third_party/rxcpp/v${rxcppVersion}.tar.gz
    find "$rxcpp_tmpdir/RxCpp-${rxcppVersion}" -type f -name "CMakeLists.txt" -exec \
      sed -i -E 's/cmake_minimum_required\(VERSION.*\)/cmake_minimum_required\(VERSION 3.5\)/g' {} +
    substituteInPlace "$rxcpp_tmpdir/RxCpp-${rxcppVersion}/Rx/v2/src/rxcpp/rx-notification.hpp" \
      --replace-fail "{ ep = std::move(o.ep); return *this; }" "RXCPP_DELETE;"
    tar -czf third_party/rxcpp/v${rxcppVersion}.tar.gz -C "$rxcpp_tmpdir" RxCpp-${rxcppVersion}
    rxcpp_hash=$(md5sum third_party/rxcpp/v${rxcppVersion}.tar.gz | awk '{ print $1 }')
    substituteInPlace cmake/external/rxcpp.cmake \
      --replace-fail "feb89934f465bb5ac513c9adce8d3b1b" "$rxcpp_hash"

    # Patch gtest to build with CMake 4
    gtest_tmpdir=$(mktemp -d)
    tar -xzf third_party/GoogleMock/release-${gtestVersion}.tar.gz -C "$gtest_tmpdir"
    rm third_party/GoogleMock/release-${gtestVersion}.tar.gz
    find "$gtest_tmpdir/googletest-release-${gtestVersion}" -type f -name "CMakeLists.txt" -exec \
      sed -i -E 's/cmake_minimum_required\(VERSION.*\)/cmake_minimum_required\(VERSION 3.5\)/g' {} +
    tar -czf third_party/GoogleMock/release-${gtestVersion}.tar.gz -C "$gtest_tmpdir" googletest-release-${gtestVersion}
    gtest_hash=$(md5sum third_party/GoogleMock/release-${gtestVersion}.tar.gz | awk '{ print $1 }')
    substituteInPlace cmake/external/GoogleTestNMock.cmake \
      --replace-fail "16877098823401d1bf2ed7891d7dce36" "$gtest_hash"
  ''
  + lib.optionalString (!withSvmLight) ''
    # Run SVMlight scrubber
    patchShebangs scripts/light-scrubber.sh
    echo "removing SVMlight code"
    ./scripts/light-scrubber.sh
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/shogun/examples
    mv $out/share/shogun/examples/cpp $doc/share/doc/shogun/examples
    cp ../examples/undocumented/libshogun/*.cpp $doc/share/doc/shogun/examples/cpp
    rm -r $out/share
  '';

  postFixup = ''
    # CMake incorrectly calculates library path from dev prefix
    substituteInPlace $dev/lib/cmake/shogun/ShogunTargets-release.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}/lib/" "$out/lib/"
  '';

  meta = with lib; {
    description = "Toolbox which offers a wide range of efficient and unified machine learning methods";
    homepage = "http://shogun-toolbox.org/";
    license = if withSvmLight then licenses.unfree else licenses.gpl3Plus;
    maintainers = with maintainers; [
      edwtjo
      smancill
    ];
  };
})
