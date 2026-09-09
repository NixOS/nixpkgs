{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  abseil-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clickhouse-cpp";
  version = "2.6.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "clickhouse";
    repo = "clickhouse-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-szvRPqj2xarzGTVyycPlSTJkWSxwLO4EKXADS1DpO7Q=";
  };

  flattenPackagesPrefix = "absl_";
  flattenPcLookupDir = "${abseil-cpp}/lib/pkgconfig";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_ABSEIL=1"
    "-DBUILD_SHARED_LIBS=1"
  ];

  propagatedBuildInputs = [ abseil-cpp ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./clickhouse-cpp.pc.in} $out/lib/pkgconfig/clickhouse-cpp.pc
  '';

  meta = {
    description = "C++ client library for ClickHouse";
    homepage = "https://github.com/clickhouse/clickhouse-cpp";
    changelog = "https://github.com/clickhouse/clickhouse-cpp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "clickhouse-cpp";
    platforms = lib.platforms.all;
  };
})
