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
  cxxStandard ? "20",
  enableHttp ? false,
  enableGrpc ? false,
  enablePrometheus ? false,
  enableElasticSearch ? false,
  enableZipkin ? false,
  # for passthru.tests
  opentelemetry-cpp,
}:
let
  opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "v1.11.0";
    hash = "sha256-1s94AS5+bPD0/UKbI/Ox+nSZe4PGLkinUcItITVgEiQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-cpp";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AsdN70T8PBKBR674/MXoCwm7b8iI1wtqLlZLktq54hc=";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin ./0001-Disable-segfaulting-test-on-Darwin.patch;

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals (enableGrpc && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ grpc ];

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

  # TODO remove when https://github.com/NixOS/nixpkgs/pull/573523 is fixed
  enableParallelChecking = false;

  checkInputs = [
    gtest
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "OTELCPP_WITH_BENCHMARK" false)
    (lib.cmakeBool "WITH_EXAMPLES" (!enableGrpc))
    (lib.cmakeBool "OTELCPP_WITH_OTLP_HTTP" enableHttp)
    (lib.cmakeBool "OTELCPP_WITH_OTLP_GRPC" enableGrpc)
    (lib.cmakeBool "OTELCPP_WITH_PROMETHEUS" enablePrometheus)
    (lib.cmakeBool "OTELCPP_WITH_ELASTICSEARCH" enableElasticSearch)
    (lib.cmakeBool "OTELCPP_WITH_ZIPKIN" enableZipkin)
    (lib.cmakeFeature "OTELCPP_PROTO_PATH" "${opentelemetry-proto}")
  ]
  ++ lib.optionals (cxxStandard != null) [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
    (lib.cmakeFeature "OTELCPP_WITH_STL" "CXX${cxxStandard}")
  ];

  outputs = [
    "out"
    "dev"
  ];

  # "--replace-fail" would normally be preferred, since it is better at
  # highlighting obsolete/uneeded substitutions, but in this case
  # "--replace-quiet" must be used.
  # substituteInPlace with "--replace-fail" already fails if there is no
  # substitution in at least one of the specified files. Below is applied to
  # multiple files where some but not all of them match the substitution
  # strings.
  postInstall = ''
    substituteInPlace $out/lib/cmake/opentelemetry-cpp/opentelemetry-cpp*-target.cmake \
      --replace-quiet "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  passthru.updateScript = nix-update-script { };

  # For dependents that compile the protos themselves.
  passthru.opentelemetry-proto = opentelemetry-proto;

  passthru.tests = {
    # Unfortunately there is no such thing as finalAttrs.finalPackage.override,
    # so we have to resort to this.
    full = opentelemetry-cpp.override {
      enableHttp = true;
      enableGrpc = true;
      enablePrometheus = true;
      enableElasticSearch = true;
      enableZipkin = true;
    };
    http = opentelemetry-cpp.override {
      enableHttp = true;
    };
    grpc = opentelemetry-cpp.override {
      enableGrpc = true;
    };
    prometheus = opentelemetry-cpp.override {
      enablePrometheus = true;
    };
    elasticSearch = opentelemetry-cpp.override {
      enableElasticSearch = true;
    };
    zipkin = opentelemetry-cpp.override {
      enableZipkin = true;
    };
  };

  meta = {
    description = "OpenTelemetry C++ Client Library";
    homepage = "https://github.com/open-telemetry/opentelemetry-cpp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jfroche
      panicgh
    ];
    platforms = lib.platforms.all;
  };
})
