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
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-E647zdLrQK6rfmopS2eerQPdPk/YM/4sr5K6GyA/2Zw=";
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

  fetchAttrs.hash = "sha256-3Sq6zSl38WRzy0ZkSj+/2q/UBZvlUQvyHd9RriYEW9w=";

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [ adda ];
  };
}
