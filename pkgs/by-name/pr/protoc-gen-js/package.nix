{
  stdenv,
  lib,
  buildBazelPackage,
  fetchFromGitHub,
  cctools,
  bazel_6,
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

  bazel = bazel_6;
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

  fetchAttrs.hash = "sha256-B11Ny9BdRWkD8x961xz/lOdyewkwFAfL5IrVZ3LqJ0Y=";

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
