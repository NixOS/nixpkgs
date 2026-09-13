{
  stdenv,
  lib,
  buildBazelPackage,
  bazel_7,
  fetchFromGitHub,
  cctools,
}:

buildBazelPackage rec {
  pname = "protoc-gen-js";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    tag = "v${version}";
    hash = "sha256-vFTR7dwquZht4st90bFQ9CJMYBPbL+DWO0uQ3xsXIBU=";
  };

  bazel = bazel_7;
  bazelTargets = [ "generator:protoc-gen-js" ];
  bazelBuildFlags = [
    # error: module zlib~//:z does not depend on a module exporting 'stddef.h'
    "--features=-module_maps"
    # error: module abseil-cpp~//absl/crc:crc_internal does not depend on a module exporting 'arm_acle.h'
    "--host_features=-module_maps"
    # error: 'clock_gettime' is only available on macOS 10.12 or newer
    "--macos_minimum_os=10.12"
    "--host_macos_minimum_os=10.12"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = lib.getExe' cctools "libtool";
  };

  fetchAttrs = {
    hash = "sha256-Oy7FiOCDmDBBPfKvkz8JTDt45iw8uJvgUvCAnhay4Bw=";
  };

  buildAttrs.installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bazel-bin/generator/protoc-gen-js $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Protobuf plugin for generating JavaScript code";
    mainProgram = "protoc-gen-js";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    platforms = with lib.platforms; linux ++ darwin;
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [
      prince213
    ];
  };
}
