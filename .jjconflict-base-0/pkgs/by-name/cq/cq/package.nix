{ lib
, fetchFromGitHub
, fetchurl
, buildGraalvmNativeImage
, graalvmCEPackages
}:

buildGraalvmNativeImage rec {
  pname = "cq";
  version = "2024.06.24-12.10";

  # we need both src (the prebuild jar)
  src = fetchurl {
    url = "https://github.com/markus-wa/cq/releases/download/${version}/cq.jar";
    hash = "sha256-iULV+j/AuGVYPYhbOTQTKd3n+VZhWQYBRE6cRiaa1/M=";
  };

  # and build-src (for the native-image build process)
  build-src = fetchFromGitHub {
    owner = "markus-wa";
    repo = "cq";
    rev = version;
    hash = "sha256-yjAC2obipdmh+JlHzVUTMtTXN2VKe4WKkyJyu2Q93c8=";
  };

  graalvmDrv = graalvmCEPackages.graalvm-ce;

  executable = "cq";

  # copied verbatim from the upstream build script https://github.com/markus-wa/cq/blob/main/package/build-native.sh#L5
  extraNativeImageBuildArgs = [
    "--report-unsupported-elements-at-runtime"
    "--initialize-at-build-time"
    "--no-server"
    "-H:ReflectionConfigurationFiles=${build-src}/package/reflection-config.json"
  ];

  meta = with lib; {
    description = "Clojure Query: A Command-line Data Processor for JSON, YAML, EDN, XML and more";
    homepage = "https://github.com/markus-wa/cq";
    changelog = "https://github.com/markus-wa/cq/releases/releases/tag/${version}";
    license = licenses.epl20;
    maintainers = with maintainers; [ farcaller ];
    platforms = platforms.unix;
  };
}
