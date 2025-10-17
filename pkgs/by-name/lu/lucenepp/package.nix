{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  gtest,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "lucene++";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "luceneplusplus";
    repo = "LucenePlusPlus";
    rev = "rel_${version}";
    hash = "sha256-VxEV45OXHRldFdIt2OC6O7ey5u98VQzlzeOb9ZiKfd8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    gtest
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "ENABLE_TEST" doCheck)
  ];

  patches = [
    (fetchpatch {
      name = "fix-build-with-boost-1_85_0.patch";
      url = "https://github.com/luceneplusplus/LucenePlusPlus/commit/76dc90f2b65d81be018c499714ff11e121ba5585.patch";
      hash = "sha256-SNAngHwy7yxvly8d6u1LcPsM6NYVx3FrFiSHLmkqY6Q=";
    })
    (fetchpatch {
      name = "fix-install-path-for-liblucene_pc.patch";
      url = "https://github.com/luceneplusplus/LucenePlusPlus/commit/f40f59c6e169b4e16b7a6439ecb26a629c6540d1.patch";
      hash = "sha256-YtZMqh/cnkGikatcgRjOWXj570M5ZOnCqgW8/K0/nVo=";
    })
    (fetchpatch {
      name = "migrate-to-boost_asio_io_context.patch";
      url = "https://github.com/luceneplusplus/LucenePlusPlus/commit/e6a376836e5c891577eae6369263152106b9bc02.patch";
      hash = "sha256-0mdVvrS0nTxSJXRzVdx2Zb/vm9aVxGfARG/QliRx7tA=";
    })
    (fetchpatch {
      name = "Bump-minimum-required-cmake-version-to-3_10.patch";
      url = "https://github.com/luceneplusplus/LucenePlusPlus/commit/2857419531c45e542afdc52001a65733f4f9b128.patch";
      hash = "sha256-qgXnDhJIa32vlw3MRLbOWsBMj67d9n+ZFLn+yHpU9Hk=";
    })
  ];

  # Don't use the built in gtest - but the nixpkgs one requires C++14.
  postPatch = ''
    substituteInPlace src/test/CMakeLists.txt \
      --replace-fail "add_subdirectory(gtest)" ""
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 14)"
  '';

  # FIXME: Stuck for several hours after passing 1472 tests
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    LD_LIBRARY_PATH=$PWD/src/contrib:$PWD/src/core \
            src/test/lucene++-tester
    runHook postCheck
  '';

  meta = {
    description = "C++ port of the popular Java Lucene search engine";
    homepage = "https://github.com/luceneplusplus/LucenePlusPlus";
    license = with lib.licenses; [
      asl20
      lgpl3Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wineee ];
  };
}
