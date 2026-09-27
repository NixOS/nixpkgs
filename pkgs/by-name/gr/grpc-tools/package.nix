{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grpc-tools";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    tag = "grpc-tool@${finalAttrs.version}";
    hash = "sha256-bLG7hIKr0maFu/at4Vmf59YMwGAnAEOdPbRlGLasm2k=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/packages/grpc-tools";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Fix configure with cmake4 for the vendored protobuf
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  installPhase = ''
    install -Dm755 -t $out/bin grpc_node_plugin
    install -Dm755 -t $out/bin deps/protobuf/protoc
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
})
