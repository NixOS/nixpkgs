{
  lib,
  stdenv,
  fetchFromGitHub,
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
    rev = "v1.7.0";
    hash = "sha256-3SFf/7fStrglxcpwEya7hDp8Sr3wBG9OYyBoR78IUgs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-cpp";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4SmKB2368I/2WTKYCqsZAAdkJygA15zCT+I7/RF8Knk=";
  };

  patches = [
    ./0001-Disable-tests-requiring-network-access.patch
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin ./0002-Disable-segfaulting-test-on-Darwin.patch;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    nlohmann_json
  ];

  propagatedBuildInputs =
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

  cmakeFlags = [
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
    substituteInPlace $out/lib/cmake/opentelemetry-cpp/opentelemetry-cpp*-target.cmake \
      --replace-quiet "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTelemetry C++ Client Library";
    homepage = "https://github.com/open-telemetry/opentelemetry-cpp";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [
      jfroche
      panicgh
    ];
    platforms = lib.platforms.all;
    # https://github.com/protocolbuffers/protobuf/issues/14492
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
