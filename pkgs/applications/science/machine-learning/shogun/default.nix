{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
  # build
, cmake
, ctags
, python3Packages
, swig
  # math
, eigen
, blas
, lapack
, glpk
  # data
, protobuf
, json_c
, libxml2
, hdf5
, curl
  # compression
, libarchive
, bzip2
, xz
, snappy
, lzo
  # more math
, nlopt
, lp_solve
, colpack
  # extra support
, pythonSupport ? false
, opencvSupport ? false
, opencv ? null
, withSvmLight ? false
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
      rev =  "shogun_${version}";
      sha256 = "sha256-38aULxK50wQ2+/ERosSpRyBmssmYSGv5aaWfWSlrSRc=";
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

stdenv.mkDerivation rec {
  inherit pname version;

  outputs = [ "out" "dev" "doc" ];

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

  ] ++ lib.optional (!withSvmLight) ./svmlight-scrubber.patch;

  nativeBuildInputs = [ cmake swig ctags ]
    ++ (with python3Packages; [ python jinja2 ply ]);

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
  ] ++ lib.optionals pythonSupport (with python3Packages; [ python numpy ])
    ++ lib.optional opencvSupport opencv;

  cmakeFlags = let
    enableIf = cond: if cond then "ON" else "OFF";
    excludeTestsRegex = lib.concatStringsSep "|" [
      # sporadic segfault
      "TrainedModelSerialization"
      # broken by openblas 0.3.21
      "mathematics_lapack"
      # these take too long on CI
      "evaluation_cross_validation"
      "modelselection_combined_kernel"
      "modelselection_grid_search"
    ];
  in [
    "-DBUILD_META_EXAMPLES=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_ARPACK=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_ARPREC=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_CPLEX=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_Mosek=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_TFLogger=ON"
    "-DCMAKE_DISABLE_FIND_PACKAGE_ViennaCL=ON"
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'${excludeTestsRegex}'"
    "-DENABLE_TESTING=${enableIf doCheck}"
    "-DDISABLE_META_INTEGRATION_TESTS=ON"
    "-DTRAVIS_DISABLE_META_CPP=ON"
    "-DINTERFACE_PYTHON=${enableIf pythonSupport}"
    "-DOpenCV=${enableIf opencvSupport}"
    "-DUSE_SVMLIGHT=${enableIf withSvmLight}"
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
  '' + lib.optionalString (!withSvmLight) ''
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
      --replace "\''${_IMPORT_PREFIX}/lib/" "$out/lib/"
  '';

  meta = with lib; {
    description = "Toolbox which offers a wide range of efficient and unified machine learning methods";
    homepage = "http://shogun-toolbox.org/";
    license = if withSvmLight then licenses.unfree else licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo smancill ];
  };
}
