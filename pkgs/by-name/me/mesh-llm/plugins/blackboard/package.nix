{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-blackboard-plugin";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "blackboard-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gfQR2F8ehpPvhHOkozeArPiTB7NKGaJNkxll6sur5CU=";
  };

  cargoHash = "sha256-SWkgwxn/zgzGs9hHHBoYNndmyVGtc3WnjxC7bJm2a/E=";

  __structuredAttrs = true;
  strictDeps = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "blackboard";
    protocolVersion = 3;
  };

  meta = {
    description = "Blackboard collaboration plugin for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/blackboard-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "blackboard";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
