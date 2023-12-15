{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, boost
, rdkafka
, gtest
, rapidjson
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
      name = "fix-avoid-overwriting-library-paths.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/pull/221.patch";
      hash = "sha256-UsQcMvJoRTn5kgXhmXOyqfW3n59kGKO596U2WjtdqAY=";
    })
    (fetchpatch {
      name = "add-pkg-config-cmake-config.patch";
      url = "https://github.com/morganstanley/modern-cpp-kafka/pull/222.patch";
      hash = "sha256-OjoSttnpgEwSZjCVKc888xJb5f1Dulu/rQqoGmqXNM4=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];
  propagatedBuildInputs = [ rdkafka ];

  cmakeFlags = [
    "-DLIBRDKAFKA_INCLUDE_DIR=${rdkafka.out}/include"
    "-DGTEST_LIBRARY_DIR=${gtest.out}/lib"
    "-DGTEST_INCLUDE_DIR=${gtest.dev}/include"
    "-DRAPIDJSON_INCLUDE_DIRS=${rapidjson.out}/include"
    "-DCMAKE_CXX_FLAGS=-Wno-uninitialized"
  ];

  checkInputs = [ gtest rapidjson ];

  meta = with lib; {
    description = "A C++ API for Kafka clients (i.e. KafkaProducer, KafkaConsumer, AdminClient)";
    homepage = "https://github.com/morganstanley/modern-cpp-kafka";
    license = licenses.asl20;
    maintainers = with maintainers; [ ditsuke ];
    platforms = platforms.unix;
  };
}
