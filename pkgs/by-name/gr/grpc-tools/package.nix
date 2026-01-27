{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "grpc-tools";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    tag = "grpc-tool@${version}";
    hash = "sha256-bLG7hIKr0maFu/at4Vmf59YMwGAnAEOdPbRlGLasm2k=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/grpc-tools";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Fix configure with cmake4 for the vendored protobuf
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  installPhase = ''
    install -Dm755 -t $out/bin grpc_node_plugin
    install -Dm755 -t $out/bin deps/protobuf/protoc
    # The node script creates two additional binaries that just forward their inputs to the above programs,
    # but it seems unnecessary to install node etc just for this. So let's fake it using regular bash.
    # https://github.com/grpc/grpc-node/blob/179dbfaeccc19bce786788a6b8e986990ab51329/packages/grpc-tools/package.json#L19-L21
    cat >$out/bin/grpc_tools_node_protoc <<EOL
    #/usr/bin/env bash
    $out/bin/protoc --plugin=protoc-gen-grpc=$out/bin/grpc_node_plugin "\$@"
    EOL
    chmod +x $out/bin/grpc_tools_node_protoc
    # grpc_tools_node_protoc_plugin seems to literally be the same as grpc_node_plugin
    # except with a node wrapper
    ln -s $out/bin/grpc_node_plugin $out/bin/grpc_tools_node_protoc_plugin
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/grpc/grpc-node.git";
    rev-prefix = "grpc-tools@";
  };

  meta = {
    description = "Distribution of protoc and the gRPC Node protoc plugin for ease of installation with npm";
    longDescription = ''
      This package distributes the Protocol Buffers compiler protoc along with
      the plugin for generating client and service objects for use with the Node
      gRPC libraries.
    '';
    homepage = "https://github.com/grpc/grpc-node/tree/master/packages/grpc-tools";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nzhang-zh ];
  };
}
