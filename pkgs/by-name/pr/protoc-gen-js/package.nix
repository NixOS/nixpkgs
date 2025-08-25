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
  version = "3.21.4";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-eIOtVRnHv2oz4xuVc4aL6JmhpvlODQjXHt1eJHsjnLg=";
  };

  bazel = bazel_7;
  bazelTargets = [ "generator:protoc-gen-js" ];
  bazelBuildFlags = lib.optionals stdenv.cc.isClang [
    "--cxxopt=-x"
    "--cxxopt=c++"
    "--host_cxxopt=-x"
    "--host_cxxopt=c++"
  ];
  removeRulesCC = false;
  removeLocalConfigCC = false;

  LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

  fetchAttrs = {
    preInstall = ''
      rm -rv "$bazelOut/external/host_platform"
    '';

    hash = "sha256-CekpXINZSr6Hysa4qrVkdchBla9pgBwRtqBiuUGPNq0=";
  };

  buildAttrs.installPhase = ''
    mkdir -p $out/bin
    install -Dm755 bazel-bin/generator/protoc-gen-js $out/bin/
  '';

  meta = with lib; {
    description = "Protobuf plugin for generating JavaScript code";
    mainProgram = "protoc-gen-js";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    platforms = platforms.linux ++ platforms.darwin;
    license = with licenses; [
      asl20
      bsd3
    ];
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = [ ];
  };
}
