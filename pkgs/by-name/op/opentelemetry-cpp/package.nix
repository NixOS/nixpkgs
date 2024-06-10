{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, protobuf
, curl
, grpc
, prometheus-cpp
, nlohmann_json
, nix-update-script
}:

let
  opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "v1.0.0";
    hash = "sha256-1IylAZs8gElpruSX52A+ZopU8jXH/MjRE+FQV3gQ+Gk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-cpp";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tf1ZnmHavnwwvRb4Tes20LMld+w/2kRo5UErT8pHf3w=";
  };

  patches = [
    ./0001-Disable-tests-requiring-network-access.patch
  ] ++ lib.optional stdenv.isDarwin ./0002-Disable-segfaulting-test-on-Darwin.patch;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    grpc
    nlohmann_json
    prometheus-cpp
    protobuf
  ];

  doCheck = true;

  checkInputs = [
    gtest
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWITH_OTLP_HTTP=ON"
    "-DWITH_OTLP_GRPC=ON"
    "-DWITH_ABSEIL=ON"
    "-DWITH_PROMETHEUS=ON"
    "-DWITH_ELASTICSEARCH=ON"
    "-DWITH_ZIPKIN=ON"
    "-DWITH_BENCHMARK=OFF"
    "-DOTELCPP_PROTO_PATH=${opentelemetry-proto}"
  ];

  outputs = [ "out" "dev" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTelemetry C++ Client Library";
    homepage = "https://github.com/open-telemetry/opentelemetry-cpp";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ jfroche ];
    # https://github.com/protocolbuffers/protobuf/issues/14492
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
