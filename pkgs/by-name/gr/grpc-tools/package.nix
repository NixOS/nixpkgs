{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "grpc-tools";
  version = "1.12.4";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    tag = "grpc-tools@${version}";
    hash = "sha256-708lBIGW5+vvSTrZHl/kc+ck7JKNXElrghIGDrMSyx8=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/grpc-tools";

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 -t $out/bin grpc_node_plugin
    install -Dm755 -t $out/bin deps/protobuf/protoc
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/grpc/grpc-node.git";
    rev-prefix = "grpc-tools@";
  };

  meta = with lib; {
    description = "Distribution of protoc and the gRPC Node protoc plugin for ease of installation with npm";
    longDescription = ''
      This package distributes the Protocol Buffers compiler protoc along with
      the plugin for generating client and service objects for use with the Node
      gRPC libraries.
    '';
    homepage = "https://github.com/grpc/grpc-node/tree/master/packages/grpc-tools";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.nzhang-zh ];
  };
}
