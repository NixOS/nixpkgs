{
  bazel,
  buildBazelPackage,
  fetchFromGitHub,
  lib,
}:

buildBazelPackage rec {
  pname = "protoc-gen-grpc-java";
  version = "1.68.1";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-java";
    rev = "v${version}";
    hash = "sha256-bkUG33d3cRsyMlFaoKrY1zlmKDGIwBVj4f4DPzdPwh4=";
  };

  inherit bazel;
  bazelTargets = [ "compiler:grpc_java_plugin" ];
  fetchAttrs.sha256 = "sha256-tpvtEInRVG5bgrImtLgZxl8VF442i8sB1GxxOdWxGXg=";
  buildAttrs.installPhase = "install -D --strip bazel-bin/compiler/grpc_java_plugin $out/bin/protoc-gen-grpc-java";
  removeRulesCC = false;

  meta = with lib; {
    description = "gRPC Java Codegen Plugin for Protobuf Compiler";
    mainProgram = "protoc-gen-grpc-java";
    homepage = "https://github.com/grpc/grpc-java/blob/master/compiler/README.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ eigengrau ];
    platforms = platforms.linux;
  };
}
