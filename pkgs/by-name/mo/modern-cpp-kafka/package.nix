{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  rdkafka,
  gtest,
  rapidjson,
}:

stdenv.mkDerivation rec {
  pname = "modern-cpp-kafka";
  version = "2023.03.07";

  src = fetchFromGitHub {
    repo = "modern-cpp-kafka";
    owner = "morganstanley";
    rev = "v${version}";
    hash = "sha256-7hkwM1YbveQpDRqwMZ3MXM88LTwlAT7uB8NL0t409To=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/morganstanley/modern-cpp-kafka/pull/221
      name = "fix-avoid-overwriting-library-paths.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/compare/a146d10bcf166f55299c7a55728abaaea52cb0e5...a0b5ec08315759097ce656813be57b2c38d79091.patch";
      hash = "sha256-UsQcMvJoRTn5kgXhmXOyqfW3n59kGKO596U2WjtdqAY=";
    })
    (fetchpatch {
      # https://github.com/morganstanley/modern-cpp-kafka/pull/222
      name = "add-pkg-config-cmake-config.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/commit/edc576ab83710412f6201e2bb8de5cb41682ee4a.patch";
      hash = "sha256-OjoSttnpgEwSZjCVKc888xJb5f1Dulu/rQqoGmqXNM4=";
    })
    # Fix gcc-13 build failure:
    #   https://github.com/morganstanley/modern-cpp-kafka/pull/229
    (fetchpatch {
      name = "add-pkg-config-cmake-config.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/commit/236f8f91f5c3ad6e1055a6f55cd3aebd218e1226.patch";
      hash = "sha256-cy568TQUu08sadq79hDz9jMvDqiDjfr+1cLMxFWGm1Q=";
    })
    (fetchpatch {
      name = "macos-find-dylib.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/commit/dc2753cd95b607a7202b40bad3aad472558bf350.patch";
      hash = "sha256-Te3GwAVRDyb6GFWlvkq1mIcNeXCtMyLr+/w1LilUYbE=";
    })
  ];

  postPatch = ''
    # Blanket -Werror tends to fail on minor unrelated warnings.
    # Currently this fixes gcc-13 build failure.
    substituteInPlace CMakeLists.txt --replace-fail '"-Werror"' ' '
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];
  propagatedBuildInputs = [ rdkafka ];

  cmakeFlags =
    let
      inherit (lib) cmakeFeature getLib getInclude;
    in
    [
      (cmakeFeature "LIBRDKAFKA_LIBRARY_DIR" "${getLib rdkafka}/lib")
      (cmakeFeature "LIBRDKAFKA_INCLUDE_DIR" "${getInclude rdkafka}/include")
      (cmakeFeature "GTEST_LIBRARY_DIR" "${getLib gtest}/lib")
      (cmakeFeature "GTEST_INCLUDE_DIR" "${getInclude gtest}/include")
      (cmakeFeature "RAPIDJSON_INCLUDE_DIRS" "${getInclude rapidjson}/include")
      (cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-uninitialized")
    ];

  checkInputs = [
    gtest
    rapidjson
  ];

  meta = with lib; {
    description = "C++ API for Kafka clients (i.e. KafkaProducer, KafkaConsumer, AdminClient)";
    homepage = "https://github.com/morganstanley/modern-cpp-kafka";
    license = licenses.asl20;
    maintainers = with maintainers; [ ditsuke ];
    platforms = platforms.unix;
  };
}
