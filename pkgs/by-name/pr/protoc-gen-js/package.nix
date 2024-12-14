{ stdenv, lib, buildBazelPackage, bazel_6, fetchFromGitHub, cctools }:

buildBazelPackage rec {
  pname = "protoc-gen-js";
  version = "3.21.2";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-TmP6xftUVTD7yML7UEM/DB8bcsL5RFlKPyCpcboD86U=";
  };

  bazel = bazel_6;
  bazelTargets = [ "generator:protoc-gen-js" ];
  bazelBuildFlags = lib.optionals stdenv.cc.isClang [ "--cxxopt=-x" "--cxxopt=c++" "--host_cxxopt=-x" "--host_cxxopt=c++" ];
  removeRulesCC = false;
  removeLocalConfigCC = false;

  LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

  fetchAttrs.hash = "sha256-F1xVqpMNEn8iDNy5zWm1PPa83TT3/4X74Z29sIuIuys=";

  buildAttrs.installPhase = ''
    mkdir -p $out/bin
    install -Dm755 bazel-bin/generator/protoc-gen-js $out/bin/
  '';

  meta = with lib; {
    description = "Protobuf plugin for generating JavaScript code";
    mainProgram = "protoc-gen-js";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    platforms = platforms.linux ++ platforms.darwin;
    license = with licenses; [ asl20 bsd3 ];
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = [ ];
  };
}
