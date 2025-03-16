{
  lib,
  stdenv,
  fetchFromGitHub,
  abseil-cpp,
  cmake,
  gtest,
  protobuf,
  curl,
  grpc,
  prometheus-cpp,
  nlohmann_json,
  nix-update-script,
  cxxStandard ? null,
  enableHttp ? false,
  enableGrpc ? false,
  enablePrometheus ? false,
  enableElasticSearch ? false,
  enableZipkin ? false,
}:
let
  opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "v1.3.2";
    hash = "sha256-bkVqPSVhyMHrmFvlI9DTAloZzDozj3sefIEwfW7OVrI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-cpp";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-31zwIZ4oehhfn+oCyg8VQTurPOmdgp72plH1Pf/9UKQ=";
  };

  patches = [
    ./0001-Disable-tests-requiring-network-access.patch
  ] ++ lib.optional stdenv.hostPlatform.isDarwin ./0002-Disable-segfaulting-test-on-Darwin.patch;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    nlohmann_json
  ];

  propagatedBuildInputs =
    [ abseil-cpp ]
    ++
    lib.optionals (enableGrpc || enableHttp) [ protobuf ]
    ++ lib.optionals enableGrpc [
      grpc
    ]
    ++ lib.optionals enablePrometheus [
      prometheus-cpp
    ];

  doCheck = true;

  checkInputs = [
    gtest
  ];

  strictDeps = true;

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
      (lib.cmakeBool "WITH_BENCHMARK" false)
      (lib.cmakeBool "WITH_OTLP_HTTP" enableHttp)
      (lib.cmakeBool "WITH_OTLP_GRPC" enableGrpc)
      (lib.cmakeBool "WITH_PROMETHEUS" enablePrometheus)
      (lib.cmakeBool "WITH_ELASTICSEARCH" enableElasticSearch)
      (lib.cmakeBool "WITH_ZIPKIN" enableZipkin)
      (lib.cmakeFeature "OTELCPP_PROTO_PATH" "${opentelemetry-proto}")
    ]
    ++ lib.optionals (cxxStandard != null) [
      (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
      (lib.cmakeFeature "WITH_STL" "CXX${cxxStandard}")
    ];

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    substituteInPlace $out/lib/cmake/opentelemetry-cpp/opentelemetry-cpp-target.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTelemetry C++ Client Library";
    homepage = "https://github.com/open-telemetry/opentelemetry-cpp";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ jfroche ];
    platforms = lib.platforms.linux;
    # https://github.com/protocolbuffers/protobuf/issues/14492
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
