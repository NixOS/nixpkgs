{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGraalvmNativeImage,
  graalvmPackages,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "cq";
  version = "2024.06.24-12.10";

  # we need both src (the prebuild jar)
  src = fetchurl {
    url = "https://github.com/markus-wa/cq/releases/download/${finalAttrs.version}/cq.jar";
    hash = "sha256-iULV+j/AuGVYPYhbOTQTKd3n+VZhWQYBRE6cRiaa1/M=";
  };

  # and build-src (for the native-image build process)
  passthru.build-src = fetchFromGitHub {
    owner = "markus-wa";
    repo = "cq";
    tag = finalAttrs.version;
    hash = "sha256-yjAC2obipdmh+JlHzVUTMtTXN2VKe4WKkyJyu2Q93c8=";
  };

  # copied verbatim from the upstream build script https://github.com/markus-wa/cq/blob/main/package/build-native.sh#L5
  extraNativeImageBuildArgs = [
    "--report-unsupported-elements-at-runtime"
    "--initialize-at-build-time"
    "--no-server"
    "-H:ReflectionConfigurationFiles=${finalAttrs.finalPackage.build-src}/package/reflection-config.json"
  ];

  meta = {
    description = "Clojure Query: A Command-line Data Processor for JSON, YAML, EDN, XML and more";
    homepage = "https://github.com/markus-wa/cq";
    changelog = "https://github.com/markus-wa/cq/releases/releases/tag/${finalAttrs.version}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ farcaller ];
    platforms = lib.platforms.unix;
    mainProgram = "cq";
  };
})
