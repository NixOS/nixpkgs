{
  stdenv,
  gcc14Stdenv,
  lib,
  buildBazelPackage,
  bazel_9,
  fetchFromGitHub,
  cctools,
}:

let
  # fails to build with gcc15, see https://github.com/NixOS/nixpkgs/issues/475586
  buildBazelPackage' =
    if stdenv.cc.isGNU then
      buildBazelPackage.override {
        stdenv = gcc14Stdenv;
      }
    else
      buildBazelPackage;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0aeaaaeee4bb913e21853a0ee0b935b2c114ae3f";
    hash = "sha256-OZjzzwO2+SmlhJvkTaW26gNvmZx0amCLF6e6MGJkRlI=";
  };
in
buildBazelPackage' rec {
  pname = "protoc-gen-js";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-fcLtBXXAnK1iunrDfT9V8aX6AbaWgCeS0lcueuThM5s=";
  };

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  bazel = bazel_9;
  bazelTargets = [ "generator:protoc-gen-js" ];
  bazelBuildFlags = lib.optionals stdenv.cc.isClang [
    "--cxxopt=-x"
    "--cxxopt=c++"
    "--host_cxxopt=-x"
    "--host_cxxopt=c++"
  ];
  removeRulesCC = false;
  removeLocalConfigCC = false;

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = "${cctools}/bin/libtool";
  };

  fetchAttrs = {
    hash = "sha256-6WRtI2lZUYyhTpggoISVVq45tszttLhS+7fXx/ySwG4=";
  };

  buildAttrs.installPhase = ''
    mkdir -p $out/bin
    install -Dm755 bazel-bin/generator/protoc-gen-js $out/bin/
  '';

  meta = {
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
    description = "Protobuf plugin for generating JavaScript code";
    mainProgram = "protoc-gen-js";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [ hzeller ];
  };
}
