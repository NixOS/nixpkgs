{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGraalvmNativeImage,
  graalvmPackages,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "cq";
  version = "2026.01.09-17.19";

  # we need both src (the prebuild jar)
  src = fetchurl {
    url = "https://github.com/markus-wa/cq/releases/download/${finalAttrs.version}/cq.jar";
    hash = "sha256-CUErNKworfgKIrOQ7V5vcnudTdZzdVdyA/gsOZUOQBI=";
  };

  # and build-src (for the native-image build process)
  passthru.build-src = fetchFromGitHub {
    owner = "markus-wa";
    repo = "cq";
    tag = finalAttrs.version;
    hash = "sha256-jDhN6eYBOouqBeJ/t5DGA1WELkH1udcuvAGaQKQufiw=";
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "cq";
  };
})
